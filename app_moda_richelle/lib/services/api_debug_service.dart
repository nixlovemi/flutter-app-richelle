import 'package:flutter/foundation.dart';
import '../services/api_client.dart';

/// Simple debug service to test API connectivity
class ApiDebugService {
  final ApiClient _apiClient = ApiClient();

  /// Test basic connectivity to your Laravel API
  Future<bool> testConnection() async {
    try {
      // Try a simple GET request to check if the server is running
      // You can create a simple health check endpoint like GET /api/health
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/health', // You might need to create this endpoint or use an existing one
        (json) => json,
      );

      if (kDebugMode) {
        print('API Connection Test Result: ${response.isSuccess}');
        print('Status Code: ${response.statusCode}');
        if (response.error != null) {
          print('Error: ${response.error!.message}');
        }
      }

      return response.isSuccess;
    } catch (e) {
      if (kDebugMode) {
        print('API Connection Test Failed: $e');
      }
      return false;
    }
  }

  /// Test login endpoint with dummy credentials (for development only)
  Future<void> testLoginEndpoint() async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/login',
        (json) => json,
        body: {
          'email': 'test@test.com',
          'password': 'password123',
        },
        requireAuth: false,
      );

      if (kDebugMode) {
        print('Login Test Result: ${response.isSuccess}');
        print('Status Code: ${response.statusCode}');
        
        if (response.isSuccess) {
          print('Response Data: ${response.data}');
        } else {
          print('Error: ${response.error?.message}');
          print('Error Details: ${response.error?.errors}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Login Test Failed: $e');
      }
    }
  }

  /// Print current API configuration
  void printApiConfig() {
    if (kDebugMode) {
      print('=== API Configuration ===');
      print('Base API URL: ${_apiClient.baseApiUrl}');
      print('Current Auth Token: ${_apiClient.authToken ?? 'None'}');
      print('========================');
    }
  }
}