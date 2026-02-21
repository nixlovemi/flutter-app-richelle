import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for securely storing authentication tokens using encrypted storage
class TokenStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userFirstNameKey = 'user_first_name';
  static const String _userLastNameKey = 'user_last_name';

  /// Get the appropriate storage method based on platform
  static Future<void> _writeValue(String key, String value) async {
    try {
      if (kIsWeb) {
        // For web, use SharedPreferences as fallback
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(key, value);
        if (kDebugMode) {
          debugPrint('💾 TokenStorageService: Saved to SharedPreferences (web): $key');
        }
      } else {
        // For mobile platforms, use secure storage
        await _storage.write(key: key, value: value);
        if (kDebugMode) {
          debugPrint('💾 TokenStorageService: Saved to SecureStorage (mobile): $key');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🚨 TokenStorageService: Error writing $key: $e');
      }
      rethrow;
    }
  }

  static Future<String?> _readValue(String key) async {
    try {
      if (kIsWeb) {
        // For web, use SharedPreferences as fallback
        final prefs = await SharedPreferences.getInstance();
        final value = prefs.getString(key);
        if (kDebugMode) {
          debugPrint('📖 TokenStorageService: Read from SharedPreferences (web): $key = ${value != null ? 'value found' : 'null'}');
        }
        return value;
      } else {
        // For mobile platforms, use secure storage
        final value = await _storage.read(key: key);
        if (kDebugMode) {
          debugPrint('📖 TokenStorageService: Read from SecureStorage (mobile): $key = ${value != null ? 'value found' : 'null'}');
        }
        return value;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🚨 TokenStorageService: Error reading $key: $e');
      }
      return null;
    }
  }

  static Future<void> _deleteValue(String key) async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(key);
        if (kDebugMode) {
          debugPrint('🗑️ TokenStorageService: Deleted from SharedPreferences (web): $key');
        }
      } else {
        await _storage.delete(key: key);
        if (kDebugMode) {
          debugPrint('🗑️ TokenStorageService: Deleted from SecureStorage (mobile): $key');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🚨 TokenStorageService: Error deleting $key: $e');
      }
    }
  }

  /// Save authentication token and user data
  static Future<void> saveAuthData({
    required String token,
    required int userId,
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    try {
      await Future.wait([
        _writeValue(_tokenKey, token),
        _writeValue(_userIdKey, userId.toString()),
        _writeValue(_userEmailKey, email),
        _writeValue(_userFirstNameKey, firstName),
        _writeValue(_userLastNameKey, lastName),
      ]);
      if (kDebugMode) {
        debugPrint('💾 TokenStorageService: Auth data saved successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🚨 TokenStorageService: Error saving auth data: $e');
      }
      rethrow;
    }
  }

  /// Get stored authentication token
  static Future<String?> getToken() async {
    try {
      final token = await _readValue(_tokenKey);
      if (kDebugMode) {
        debugPrint('💾 TokenStorageService: Retrieved token ${token != null ? '(${token.length} chars)' : '(null)'}');
      }
      return token;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🚨 TokenStorageService: Error reading token: $e');
      }
      return null;
    }
  }

  /// Get stored user data
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      final results = await Future.wait([
        _readValue(_userIdKey),
        _readValue(_userEmailKey),
        _readValue(_userFirstNameKey),
        _readValue(_userLastNameKey),
      ]);
      
      final userIdStr = results[0];
      final email = results[1];
      final firstName = results[2];
      final lastName = results[3];

      if (userIdStr != null && email != null && firstName != null && lastName != null) {
        final userData = {
          'id': int.parse(userIdStr),
          'email': email,
          'first_name': firstName,
          'last_name': lastName,
        };
        if (kDebugMode) {
          debugPrint('💾 TokenStorageService: Retrieved user data for user ID: ${userData['id']}');
        }
        return userData;
      } else {
        if (kDebugMode) {
          debugPrint('💾 TokenStorageService: Incomplete user data found');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🚨 TokenStorageService: Error getting user data: $e');
      }
      return null;
    }
    
    return null;
  }

  /// Check if user is logged in (has valid token)
  static Future<bool> isLoggedIn() async {
    try {
      final token = await getToken();
      final isLoggedIn = token != null && token.isNotEmpty;
      if (kDebugMode) {
        debugPrint('💾 TokenStorageService: isLoggedIn check result: $isLoggedIn');
      }
      return isLoggedIn;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🚨 TokenStorageService: Error checking login status: $e');
      }
      return false;
    }
  }

  /// Clear all stored authentication data
  static Future<void> clearAuthData() async {
    try {
      await Future.wait([
        _deleteValue(_tokenKey),
        _deleteValue(_userIdKey),
        _deleteValue(_userEmailKey),
        _deleteValue(_userFirstNameKey),
        _deleteValue(_userLastNameKey),
      ]);
      if (kDebugMode) {
        debugPrint('💾 TokenStorageService: All auth data cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🚨 TokenStorageService: Error clearing auth data: $e');
      }
    }
  }

  /// Update only the token (for token refresh scenarios)
  static Future<void> updateToken(String newToken) async {
    await _writeValue(_tokenKey, newToken);
    if (kDebugMode) {
      debugPrint('💾 TokenStorageService: Token updated');
    }
  }
}