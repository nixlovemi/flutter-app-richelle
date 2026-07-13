import '../models/api_response.dart';
import 'base_api_service.dart';

/// Example API service for user-related operations
/// This demonstrates how to create API services that automatically use authentication
class UserApiService extends BaseApiService {
  
  /// Get user profile information
  Future<ApiResponse<Map<String, dynamic>>> getUserProfile() async {
    return await apiClient.get<Map<String, dynamic>>(
      '/user/profile',
      (json) => json,
      requireAuth: true,
    );
  }

  /// Update user profile
  Future<ApiResponse<Map<String, dynamic>>> updateUserProfile({
    required String firstName,
    required String lastName,
  }) async {
    return await apiClient.put<Map<String, dynamic>>(
      '/user/profile',
      (json) => json,
      body: {
        'first_name': firstName,
        'last_name': lastName,
      },
      requireAuth: true,
    );
  }

  /// Get user orders
  Future<ApiResponse<List<Map<String, dynamic>>>> getUserOrders() async {
    return await apiClient.get<List<Map<String, dynamic>>>(
      '/user/orders',
      (json) => (json as List).cast<Map<String, dynamic>>(),
      requireAuth: true,
    );
  }

  /// Example: Get user data with custom headers (if needed)
  Future<void> exampleCustomRequest() async {
    // Get auth headers for use with other HTTP clients
    final headers = await getAuthHeaders();
    
    // Now you can use these headers with any HTTP client
    // For example, with the standard http package:
    // final response = await http.get(
    //   Uri.parse('$baseUrl/user/custom-endpoint'),
    //   headers: headers,
    // );
    
    print('Auth headers ready for custom request: $headers');
  }
}