import 'api_client.dart';

/// Base API service class that provides common functionality for all API services
/// All other API services should extend this class to get automatic authentication
abstract class BaseApiService {
  /// Get the shared ApiClient instance
  ApiClient get apiClient => ApiClient.instance;

  /// Get the base API URL
  String get baseUrl => apiClient.baseApiUrl;

  /// Check if user is authenticated before making requests
  Future<bool> isAuthenticated() async {
    return await ApiClient.isAuthenticated();
  }

  /// Get current auth token
  Future<String?> getCurrentToken() async {
    return await ApiClient.getCurrentToken();
  }

  /// Get authenticated headers for custom HTTP requests
  Future<Map<String, String>> getAuthHeaders({bool includeAuth = true}) async {
    return await ApiClient.getAuthHeaders(includeAuth: includeAuth);
  }

  /// Get public headers (no authentication)
  Map<String, String> getPublicHeaders() {
    return ApiClient.getPublicHeaders();
  }
}