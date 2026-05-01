import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/api_response.dart';
import '../models/api_error.dart';
import '../models/api_wrapper.dart';
import '../translations/app_translations.dart';
import 'token_storage_service.dart';
import 'error_message_service.dart';

/// Main API client for handling HTTP requests to the Laravel backend
/// Uses singleton pattern to ensure consistent authentication across the app
class ApiClient {
  static const Duration _timeout = ApiConfig.requestTimeout;

  // Singleton pattern
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal() {
    // Log environment info when ApiClient is created
    if (kDebugMode) {
      print('🌐 ApiClient: ${ApiConfig.environmentInfo}');
    }
  }

  String? _authToken;

  /// Get the shared instance of ApiClient
  static ApiClient get instance => _instance;

  /// Get the full API URL
  String get baseApiUrl => ApiConfig.fullApiUrl;

  /// Get current environment info (useful for debugging)
  static String get environmentInfo => ApiConfig.environmentInfo;

  /// Check if running in production mode
  static bool get isProduction => ApiConfig.isProduction;

  /// Check if running in development mode  
  static bool get isDevelopment => ApiConfig.isDevelopment;

  /// Set the authentication token
  void setAuthToken(String? token) {
    _authToken = token;
  }

  /// Get the current authentication token
  String? get authToken => _authToken;

  /// Get the current authentication token from secure storage
  /// Useful when you need the token in other parts of the app
  static Future<String?> getCurrentToken() async {
    // First try to get from memory (faster)
    if (_instance._authToken != null) {
      return _instance._authToken;
    }
    
    // If not in memory, get from secure storage
    final token = await TokenStorageService.getToken();
    if (token != null) {
      _instance.setAuthToken(token);
    }
    return token;
  }

  /// Check if user is currently authenticated (has token)
  static Future<bool> isAuthenticated() async {
    final token = await getCurrentToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear the authentication token
  void clearAuth() {
    _authToken = null;
  }

  /// Get common headers for requests
  Map<String, String> _getHeaders({bool includeAuth = false}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'API_KEY': ApiConfig.apiKey,
    };

    if (includeAuth && _authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  /// Get headers for external use (e.g., in other HTTP clients)
  /// This is useful if you want to use a different HTTP client but need the same headers
  static Future<Map<String, String>> getAuthHeaders({bool includeAuth = true}) async {
    final token = includeAuth ? await getCurrentToken() : null;
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'API_KEY': ApiConfig.apiKey,
      if (includeAuth && token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Get headers without authentication (for public endpoints)
  static Map<String, String> getPublicHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'API_KEY': ApiConfig.apiKey,
    };
  }

  /// Handle network errors consistently using ErrorMessageService
  ApiResponse<T> _handleNetworkError<T>(dynamic error) {
    final errorMessage = ErrorMessageService.getErrorMessage(error.toString());
    return ApiResponse.networkError(errorMessage);
  }

  /// Handle HTTP response and convert to ApiResponse for wrapped responses
  ApiResponse<T> _handleWrappedResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      final wrapper = ApiWrapper<T>.fromJson(jsonData, (json) => fromJson(json as Map<String, dynamic>));

      if (wrapper.isSuccess && wrapper.body != null) {
        // Success response with data
        return ApiResponse.success(wrapper.body as T, response.statusCode);
      } else {
        // Error response
        final error = ApiError(
          message: wrapper.message,
          errors: wrapper.errors,
          code: wrapper.statusCode,
        );
        return ApiResponse.error(error, response.statusCode);
      }
    } catch (e) {
      // JSON parsing error
      return ApiResponse.error(
        ApiError(
          message: '${AppTranslations.get('parseError')} $e',
          code: response.statusCode,
        ),
        response.statusCode,
      );
    }
  }

  /// Handle HTTP response and convert to ApiResponse
  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Success response
        final data = fromJson(jsonData);
        return ApiResponse.success(data, response.statusCode);
      } else {
        // Error response
        final error = ApiError.fromJson(jsonData);
        return ApiResponse.error(error, response.statusCode);
      }
    } catch (e) {
      // JSON parsing error  
      return ApiResponse.error(
        ApiError(
          message: '${AppTranslations.get('parseError')} $e',
          code: response.statusCode,
        ),
        response.statusCode,
      );
    }
  }

  /// Handle simple success responses (like logout)
  ApiResponse<bool> _handleSimpleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse.success(true, response.statusCode);
    } else {
      try {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final error = ApiError.fromJson(jsonData);
        return ApiResponse.error(error, response.statusCode);
      } catch (e) {
        return ApiResponse.error(
          ApiError(
            message: '${AppTranslations.get('requestFailed')} ${response.statusCode}',
            code: response.statusCode,
          ),
          response.statusCode,
        );
      }
    }
  }

  /// Make a GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, String>? queryParams,
    bool requireAuth = false,
  }) async {
    try {
      final uri = Uri.parse('$baseApiUrl$endpoint');
      final uriWithParams = queryParams != null
          ? uri.replace(queryParameters: queryParams)
          : uri;

      final response = await http
          .get(
            uriWithParams,
            headers: _getHeaders(includeAuth: requireAuth),
          )
          .timeout(_timeout);

      return _handleResponse<T>(response, fromJson);
    } on TimeoutException catch (e) {
      return _handleNetworkError<T>(e);
    } on SocketException catch (e) {
      return _handleNetworkError<T>(e);
    } on HttpException catch (e) {
      return _handleNetworkError<T>(e);
    } catch (e) {
      return _handleNetworkError<T>(e);
    }
  }

  /// Make a POST request with wrapped response (for Laravel API endpoints)
  Future<ApiResponse<T>> postWrapped<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, dynamic>? body,
    bool requireAuth = false,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseApiUrl$endpoint'),
            headers: _getHeaders(includeAuth: requireAuth),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(_timeout);

      return _handleWrappedResponse<T>(response, fromJson);
    } on TimeoutException catch (e) {
      return _handleNetworkError<T>(e);
    } on SocketException catch (e) {
      return _handleNetworkError<T>(e);
    } on HttpException catch (e) {
      return _handleNetworkError<T>(e);
    } catch (e) {
      return _handleNetworkError<T>(e);
    }
  }

  /// Make a POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, dynamic>? body,
    bool requireAuth = false,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseApiUrl$endpoint'),
            headers: _getHeaders(includeAuth: requireAuth),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(_timeout);

      return _handleResponse<T>(response, fromJson);
    } on TimeoutException catch (e) {
      return _handleNetworkError<T>(e);
    } on SocketException catch (e) {
      return _handleNetworkError<T>(e);
    } on HttpException catch (e) {
      return _handleNetworkError<T>(e);
    } catch (e) {
      return _handleNetworkError<T>(e);
    }
  }

  /// Make a POST request with simple boolean response (for actions like logout)
  Future<ApiResponse<bool>> postSimple(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseApiUrl$endpoint'),
            headers: _getHeaders(includeAuth: includeAuth),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(_timeout);

      return _handleSimpleResponse(response);
    } on TimeoutException catch (e) {
      return _handleNetworkError<bool>(e);
    } on SocketException catch (e) {
      return _handleNetworkError<bool>(e);
    } on HttpException catch (e) {
      return _handleNetworkError<bool>(e);
    } catch (e) {
      return _handleNetworkError<bool>(e);
    }
  }

  /// Make a PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, dynamic>? body,
    bool requireAuth = true,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseApiUrl$endpoint'),
            headers: _getHeaders(includeAuth: requireAuth),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(_timeout);

      return _handleResponse<T>(response, fromJson);
    } on TimeoutException catch (e) {
      return _handleNetworkError<T>(e);
    } on SocketException catch (e) {
      return _handleNetworkError<T>(e);
    } on HttpException catch (e) {
      return _handleNetworkError<T>(e);
    } catch (e) {
      return _handleNetworkError<T>(e);
    }
  }

  /// Make a DELETE request with simple boolean response
  Future<ApiResponse<bool>> delete(String endpoint, {bool requireAuth = true}) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseApiUrl$endpoint'),
            headers: _getHeaders(includeAuth: requireAuth),
          )
          .timeout(_timeout);

      return _handleSimpleResponse(response);
    } on TimeoutException catch (e) {
      return _handleNetworkError<bool>(e);
    } on SocketException catch (e) {
      return _handleNetworkError<bool>(e);
    } on HttpException catch (e) {
      return _handleNetworkError<bool>(e);
    } catch (e) {
      return _handleNetworkError<bool>(e);
    }
  }

  /// Make a DELETE request with body and simple boolean response
  Future<ApiResponse<bool>> deleteWithBody(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requireAuth = true,
  }) async {
    try {
      final request = http.Request('DELETE', Uri.parse('$baseApiUrl$endpoint'));
      request.headers.addAll(_getHeaders(includeAuth: requireAuth));
      
      if (body != null) {
        request.body = json.encode(body);
      }

      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);

      return _handleSimpleResponse(response);
    } on TimeoutException catch (e) {
      return _handleNetworkError<bool>(e);
    } on SocketException catch (e) {
      return _handleNetworkError<bool>(e);
    } on HttpException catch (e) {
      return _handleNetworkError<bool>(e);
    } catch (e) {
      return _handleNetworkError<bool>(e);
    }
  }

  // Convenience methods for public endpoints (no authentication required)
  
  /// Make a public GET request (no authentication)
  Future<ApiResponse<T>> getPublic<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, String>? queryParams,
  }) async {
    return await get<T>(endpoint, fromJson, queryParams: queryParams, requireAuth: false);
  }

  /// Make a public POST request (no authentication)
  Future<ApiResponse<T>> postPublic<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, dynamic>? body,
  }) async {
    return await post<T>(endpoint, fromJson, body: body, requireAuth: false);
  }

  /// Make a public POST request with wrapped response (no authentication)
  Future<ApiResponse<T>> postPublicWrapped<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, dynamic>? body,
  }) async {
    return await postWrapped<T>(endpoint, fromJson, body: body, requireAuth: false);
  }
}