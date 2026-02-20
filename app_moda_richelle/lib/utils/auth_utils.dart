import '../services/api_client.dart';
import '../services/token_storage_service.dart';

/// Utility class for easy access to authentication tokens throughout the app
/// Use this when you need tokens or auth headers in widgets or other services
class AuthUtils {
  
  /// Get the current authentication token
  /// Returns null if user is not authenticated
  static Future<String?> getToken() async {
    return await ApiClient.getCurrentToken();
  }

  /// Check if user is currently authenticated
  static Future<bool> isAuthenticated() async {
    return await ApiClient.isAuthenticated();
  }

  /// Get headers with authentication for API requests
  /// Perfect for using with any HTTP client (http, dio, etc.)
  static Future<Map<String, String>> getAuthHeaders({bool includeAuth = true}) async {
    return await ApiClient.getAuthHeaders(includeAuth: includeAuth);
  }

  /// Get headers without authentication (for public endpoints)
  static Map<String, String> getPublicHeaders() {
    return ApiClient.getPublicHeaders();
  }

  /// Get the base API URL
  static String get apiBaseUrl => ApiClient.instance.baseApiUrl;

  /// Get a formatted authorization header value
  /// Returns 'Bearer {token}' or null if not authenticated
  static Future<String?> getAuthorizationHeader() async {
    final token = await getToken();
    return token != null ? 'Bearer $token' : null;
  }

  /// Get user data from secure storage
  /// Useful for getting user info without going through AuthService
  static Future<Map<String, dynamic>?> getUserData() async {
    return await TokenStorageService.getUserData();
  }

  /// Clear all authentication data
  /// Use this for manual logout scenarios
  static Future<void> clearAuth() async {
    await TokenStorageService.clearAuthData();
    ApiClient.instance.clearAuth();
  }

  /// Example usage methods showing how to use tokens in different scenarios
  
  /// For use with http package
  static Future<Map<String, String>?> getHttpHeaders() async {
    final headers = await getAuthHeaders();
    return headers.isNotEmpty ? headers : null;
  }

  /// For use with WebSocket or other connections that need token as parameter
  static Future<String> getTokenForWebSocket() async {
    final token = await getToken();
    return token ?? '';
  }

  /// For debugging - print current auth status
  static Future<void> debugAuthStatus() async {
    final isAuth = await isAuthenticated();
    final token = await getToken();
    final userData = await getUserData();
    
    print('=== Auth Status ===');
    print('Authenticated: $isAuth');
    print('Token: ${token != null ? '${token.substring(0, 20)}...' : 'None'}');
    print('User: ${userData?['first_name']} ${userData?['last_name']}');
    print('==================');
  }
}