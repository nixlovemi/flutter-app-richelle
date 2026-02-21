import 'package:flutter/foundation.dart';
import '../models/api_response.dart';
import '../models/api_error.dart';
import '../models/login_request.dart';
import '../models/login_body.dart';
import '../models/user.dart';
import '../translations/app_translations.dart';
import 'api_client.dart';
import 'token_storage_service.dart';

/// Service for handling authentication operations
class AuthService extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient.instance;
  
  User? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;

  /// Get the current authenticated user
  User? get currentUser => _currentUser;

  /// Check if user is currently authenticated
  bool get isAuthenticated => _isAuthenticated;

  /// Check if an authentication operation is in progress
  bool get isLoading => _isLoading;

  /// Set loading state and notify listeners
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set authentication state
  void _setAuthenticationState(User? user, String? token) {
    _currentUser = user;
    _isAuthenticated = user != null;
    _apiClient.setAuthToken(token);
    notifyListeners();
  }

  /// Login with email and password 
  Future<ApiResponse<LoginBody>> login(String email, String password) async {
    _setLoading(true);
    
    try {
      final loginRequest = LoginRequest(email: email, password: password);
      
      final response = await _apiClient.postWrapped<LoginBody>(
        '/auth/login',
        (json) => LoginBody.fromJson(json),
        body: loginRequest.toJson(),
        requireAuth: false,
      );

      if (response.isSuccess && response.data != null) {
        final loginData = response.data!;
        
        if (kDebugMode) {
          debugPrint('🔐 AuthService: Login successful for user: ${loginData.user.email}');
          debugPrint('🔐 AuthService: Token received (${loginData.token.length} chars)');
        }
        
        // Store authentication data securely
        await TokenStorageService.saveAuthData(
          token: loginData.token,
          userId: loginData.user.id,
          email: loginData.user.email,
          firstName: loginData.user.firstName,
          lastName: loginData.user.lastName,
        );
        
        if (kDebugMode) {
          debugPrint('🔐 AuthService: Token and user data saved successfully');
        }
        
        // Set authentication state
        _setAuthenticationState(loginData.user, loginData.token);
        
        if (kDebugMode) {
          debugPrint('🔐 AuthService: Authentication state set');
        }
      }

      return response;
    } finally {
      _setLoading(false);
    }
  }

  /// Logout the current user
  Future<ApiResponse<bool>> logout() async {
    _setLoading(true);
    
    try {
      final response = await _apiClient.postSimple('/auth/logout');
      
      // Clear authentication data regardless of response
      // (in case the server is unreachable but we want to log out locally)
      _clearAuthenticationState();
      
      return response;
    } finally {
      _setLoading(false);
    }
  }

  /// Get current user profile from server
  Future<ApiResponse<User>> getProfile() async {
    if (!_isAuthenticated) {
      return ApiResponse.error(
        ApiError(message: AppTranslations.get('userNotAuthenticated')),
        401,
      );
    }

    return await _apiClient.get<User>(
      '/auth/user', // Adjust this endpoint to match your Laravel API
      (json) => User.fromJson(json),
    );
  }

  /// Update user profile (first name and last name)
  Future<ApiResponse<User>> updateProfile({
    required String firstName,
    required String lastName,
  }) async {
    if (!_isAuthenticated) {
      return ApiResponse.error(
        ApiError(message: AppTranslations.get('userNotAuthenticated')),
        401,
      );
    }

    _setLoading(true);
    
    try {
      final response = await _apiClient.postWrapped<User>(
        '/user/update-profile',
        (json) => User.fromJson(json['user']),
        body: {
          'first_name': firstName,
          'last_name': lastName,
        },
        requireAuth: true,
      );

      // If successful, update the current user data
      if (response.isSuccess && response.data != null) {
        _currentUser = response.data!;
        notifyListeners();
      }

      return response;
    } finally {
      _setLoading(false);
    }
  }

  /// Check if the current token is still valid
  Future<bool> verifyToken() async {
    if (kDebugMode) {
      debugPrint('🔐 AuthService: Starting token verification...');
    }
    
    if (!_isAuthenticated || _apiClient.authToken == null) {
      if (kDebugMode) {
        debugPrint('🔐 AuthService: Token verification failed - not authenticated or no token');
      }
      return false;
    }

    if (kDebugMode) {
      debugPrint('🔐 AuthService: Making API call to verify token...');
    }
    final response = await getProfile();
    
    if (kDebugMode) {
      debugPrint('🔐 AuthService: Profile response - success: ${response.isSuccess}, status: ${response.statusCode}');
    }
    
    if (!response.isSuccess) {
      if (kDebugMode) {
        debugPrint('🔐 AuthService: Token verification failed - API call unsuccessful');
        debugPrint('🔐 AuthService: Error type: ${response.error?.message}');
      }
      
      // Only clear auth if it's a 401 (unauthorized), not for network errors
      if (response.statusCode == 401) {
        if (kDebugMode) {
          debugPrint('🔐 AuthService: 401 Unauthorized - clearing authentication');
        }
        _clearAuthenticationState();
        return false;
      } else {
        if (kDebugMode) {
          debugPrint('🔐 AuthService: Non-401 error (${response.statusCode}) - keeping user logged in');
        }
        return true; // Keep user logged in for network errors
      }
    }

    if (kDebugMode) {
      debugPrint('🔐 AuthService: Token verification successful');
    }
    return true;
  }

  /// Clear all authentication data
  Future<void> _clearAuthenticationState() async {
    _currentUser = null;
    _isAuthenticated = false;
    _apiClient.clearAuth();
    await TokenStorageService.clearAuthData();
    notifyListeners();
  }

  /// Clear authentication state quickly (without storage operations)
  Future<void> _clearAuthenticationStateQuick() async {
    _currentUser = null;
    _isAuthenticated = false;
    _apiClient.clearAuth();
    notifyListeners();
  }

  /// Clear authentication (public method)
  Future<void> clearAuth() async {
    await _clearAuthenticationState();
  }

  /// Initialize authentication state (call this at app startup)
  Future<void> initializeAuth() async {
    try {
      if (kDebugMode) {
        debugPrint('🔐 AuthService: Starting auth initialization...');
      }
      
      // Check if user has a stored token
      final isLoggedIn = await TokenStorageService.isLoggedIn();
      
      if (kDebugMode) {
        debugPrint('🔐 AuthService: Stored login found: $isLoggedIn');
      }
      
      if (isLoggedIn) {
        final token = await TokenStorageService.getToken();
        final userData = await TokenStorageService.getUserData();
        
        if (kDebugMode) {
          debugPrint('🔐 AuthService: Token and user data retrieved');
        }
        
        if (token != null && userData != null) {
          // Reconstruct user object from stored data
          final user = User(
            id: userData['id'],
            firstName: userData['first_name'],
            lastName: userData['last_name'],
            email: userData['email'],
            createdAt: DateTime.now(), // Default value - consider storing this too
            updatedAt: DateTime.now(), // Default value
          );
          
          if (kDebugMode) {
            debugPrint('🔐 AuthService: User authenticated: ${user.email}');
          }
          
          // Set authentication state without immediate validation
          _currentUser = user;
          _isAuthenticated = true;
          _apiClient.setAuthToken(token);
          notifyListeners();
          
          if (kDebugMode) {
            debugPrint('🔐 AuthService: Authentication state set successfully');
          }
          
          // Verify token in background (don't block UI)
          _verifyTokenInBackground();
        } else {
          if (kDebugMode) {
            debugPrint('🔐 AuthService: Token or userData is null, clearing auth');
          }
          await _clearAuthenticationStateQuick();
        }
      } else {
        if (kDebugMode) {
          debugPrint('🔐 AuthService: No stored login found, ensuring clean state');
        }
        // Ensure state is clean
        await _clearAuthenticationStateQuick();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🚨 AuthService: Error during initialization: $e');
      }
      // Error during initialization, clear auth state
      await _clearAuthenticationStateQuick();
    }
  }

  /// Verify token in background without blocking the UI
  Future<void> _verifyTokenInBackground() async {
    try {
      if (kDebugMode) {
        debugPrint('🔐 AuthService: Starting background token verification...');
      }
      
      final isValid = await verifyToken();
      
      if (kDebugMode) {
        debugPrint('🔐 AuthService: Token verification result: $isValid');
      }
      
      if (!isValid) {
        if (kDebugMode) {
          debugPrint('🔐 AuthService: Token verification failed, clearing authentication');
        }
        // Token is invalid, clear authentication
        await _clearAuthenticationState();
      } else {
        if (kDebugMode) {
          debugPrint('🔐 AuthService: Token verification successful');
        }
      }
    } catch (e) {
      // If verification fails due to network issues, keep the user logged in
      // This prevents logout due to network issues
      if (kDebugMode) {
        debugPrint('🔐 AuthService: Background token verification failed (network issue): $e');
        debugPrint('🔐 AuthService: Keeping user logged in despite verification failure');
      }
    }
  }
}