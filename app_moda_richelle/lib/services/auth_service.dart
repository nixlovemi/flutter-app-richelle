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
        
        // Store authentication data securely
        await TokenStorageService.saveAuthData(
          token: loginData.token,
          userId: loginData.user.id,
          email: loginData.user.email,
          firstName: loginData.user.firstName,
          lastName: loginData.user.lastName,
        );
        
        // Set authentication state
        _setAuthenticationState(loginData.user, loginData.token);
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

  /// Check if the current token is still valid
  Future<bool> verifyToken() async {
    if (!_isAuthenticated || _apiClient.authToken == null) {
      return false;
    }

    final response = await getProfile();
    if (!response.isSuccess) {
      // Token is invalid, clear authentication
      _clearAuthenticationState();
      return false;
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
      // Check if user has a stored token
      final isLoggedIn = await TokenStorageService.isLoggedIn();
      
      if (isLoggedIn) {
        final token = await TokenStorageService.getToken();
        final userData = await TokenStorageService.getUserData();
        
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
          
          // Set authentication state without immediate validation
          _currentUser = user;
          _isAuthenticated = true;
          _apiClient.setAuthToken(token);
          notifyListeners();
          
          // Verify token in background (don't block UI)
          _verifyTokenInBackground();
        }
      } else {
        // Ensure state is clean
        await _clearAuthenticationStateQuick();
      }
    } catch (e) {
      // Error during initialization, clear auth state
      await _clearAuthenticationStateQuick();
    }
  }

  /// Verify token in background without blocking the UI
  Future<void> _verifyTokenInBackground() async {
    try {
      final isValid = await verifyToken();
      if (!isValid) {
        // Token is invalid, clear authentication
        await _clearAuthenticationState();
      }
    } catch (e) {
      // If verification fails, assume token is still valid
      // This prevents logout due to network issues
      debugPrint('Background token verification failed: $e');
    }
  }
}