import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  /// Save authentication token and user data
  static Future<void> saveAuthData({
    required String token,
    required int userId,
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    await Future.wait([
      _storage.write(key: _tokenKey, value: token),
      _storage.write(key: _userIdKey, value: userId.toString()),
      _storage.write(key: _userEmailKey, value: email),
      _storage.write(key: _userFirstNameKey, value: firstName),
      _storage.write(key: _userLastNameKey, value: lastName),
    ]);
  }

  /// Get stored authentication token
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Get stored user data
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      final results = await Future.wait([
        _storage.read(key: _userIdKey),
        _storage.read(key: _userEmailKey),
        _storage.read(key: _userFirstNameKey),
        _storage.read(key: _userLastNameKey),
      ]);
      
      final userIdStr = results[0];
      final email = results[1];
      final firstName = results[2];
      final lastName = results[3];

      if (userIdStr != null && email != null && firstName != null && lastName != null) {
        return {
          'id': int.parse(userIdStr),
          'email': email,
          'first_name': firstName,
          'last_name': lastName,
        };
      }
    } catch (e) {
      // Handle parsing errors or missing data
      return null;
    }
    
    return null;
  }

  /// Check if user is logged in (has valid token)
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear all stored authentication data
  static Future<void> clearAuthData() async {
    await Future.wait([
      _storage.delete(key: _tokenKey),
      _storage.delete(key: _userIdKey),
      _storage.delete(key: _userEmailKey),
      _storage.delete(key: _userFirstNameKey),
      _storage.delete(key: _userLastNameKey),
    ]);
  }

  /// Update only the token (for token refresh scenarios)
  static Future<void> updateToken(String newToken) async {
    await _storage.write(key: _tokenKey, value: newToken);
  }
}