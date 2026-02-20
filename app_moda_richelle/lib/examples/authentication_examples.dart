import '../services/api_client.dart';
import '../services/base_api_service.dart';

/// Example service demonstrating how to use authentication selectively
/// This shows how to control when tokens are included in API calls
class ExampleApiService extends BaseApiService {

  // PUBLIC ENDPOINTS (No authentication required)
  
  /// Get public product catalog (no auth needed)
  Future<void> getPublicProducts() async {
    await apiClient.getPublic<Map<String, dynamic>>(
      '/products/public',
      (json) => json,
    );
    
    // Or use the explicit parameter:
    await apiClient.get<Map<String, dynamic>>(
      '/products/public',
      (json) => json,
      requireAuth: false, // Explicitly no auth
    );
  }

  /// Public user registration (no auth needed)
  Future<void> registerUser() async {
    await apiClient.postPublic<Map<String, dynamic>>(
      '/auth/register',
      (json) => json,
      body: {
        'email': 'user@example.com',
        'password': 'password123',
        'name': 'John Doe',
      },
    );
  }

  /// Get app configuration (public endpoint)
  Future<void> getAppConfig() async {
    await apiClient.postPublicWrapped<Map<String, dynamic>>(
      '/config',
      (json) => json,
    );
  }

  // AUTHENTICATED ENDPOINTS (Token required)
  
  /// Get user's private data (auth required)
  Future<void> getUserProfile() async {
    await apiClient.get<Map<String, dynamic>>(
      '/user/profile',
      (json) => json,
      requireAuth: true, // Explicitly require auth
    );
  }

  /// Update user settings (auth required)
  Future<void> updateUserSettings() async {
    await apiClient.put<Map<String, dynamic>>(
      '/user/settings',
      (json) => json,
      body: {'theme': 'dark'},
      requireAuth: true, // Auth required
    );
  }

  /// Delete user account (auth required)
  Future<void> deleteAccount() async {
    await apiClient.delete(
      '/user/account',
      requireAuth: true, // Auth required for deletion
    );
  }

  // MIXED SCENARIOS
  
  /// Search products - can be public or authenticated for personalization
  Future<void> searchProducts({bool personalized = false}) async {
    await apiClient.get<Map<String, dynamic>>(
      '/products/search',
      (json) => json,
      queryParams: {'q': 'dress', 'limit': '20'},
      requireAuth: personalized, // Auth only if personalized results wanted
    );
  }

  /// Get product details - public info vs authenticated user's relationship
  Future<void> getProductDetails(int productId, {bool includeUserData = false}) async {
    await apiClient.get<Map<String, dynamic>>(
      '/products/$productId',
      (json) => json,
      requireAuth: includeUserData, // Auth only if user-specific data needed
    );
  }
}

/// Examples of different authentication scenarios
class AuthenticationExamples {
  
  static final _apiClient = ApiClient.instance;

  /// Example 1: Public endpoints (no token needed)
  static Future<void> publicEndpointsExample() async {
    print('=== Public Endpoints (No Authentication) ===');
    
    // These calls won't include the Authorization header
    await _apiClient.getPublic('/products/categories', (json) => json);
    await _apiClient.postPublic('/contact', (json) => json, body: {'message': 'Hello'});
    await _apiClient.get('/app/version', (json) => json, requireAuth: false);
    
    print('All public calls completed without authentication');
  }

  /// Example 2: Authenticated endpoints (token required)  
  static Future<void> authenticatedEndpointsExample() async {
    print('=== Authenticated Endpoints (Token Required) ===');
    
    // These calls will include the Authorization header with Bearer token
    await _apiClient.get('/user/profile', (json) => json, requireAuth: true);
    await _apiClient.put('/user/preferences', (json) => json, 
      body: {'language': 'en'}, requireAuth: true);
    await _apiClient.delete('/user/wishlist/123', requireAuth: true);
    
    print('All authenticated calls completed with token');
  }

  /// Example 3: Conditional authentication
  static Future<void> conditionalAuthExample(bool isUserLoggedIn) async {
    print('=== Conditional Authentication ===');
    
    // Search can work with or without authentication
    await _apiClient.get('/products/search', (json) => json,
      queryParams: {'q': 'shoes'},
      requireAuth: isUserLoggedIn, // Include token only if user is logged in
    );
    
    // Product details might show different info for authenticated users
    await _apiClient.get('/products/123', (json) => json,
      requireAuth: isUserLoggedIn, // Personalized data if authenticated
    );
    
    print('Conditional auth completed based on user status: $isUserLoggedIn');
  }

  /// Example 4: Using custom headers for different scenarios
  static Future<void> customHeadersExample() async {
    print('=== Custom Headers Example ===');
    
    // Get public headers (no auth token)
    final publicHeaders = ApiClient.getPublicHeaders();
    print('Public headers: $publicHeaders');
    
    // Get auth headers with token included
    final authHeaders = await ApiClient.getAuthHeaders(includeAuth: true);
    print('Auth headers: $authHeaders');
    
    // Get headers without auth (same as public but using different method)
    final noAuthHeaders = await ApiClient.getAuthHeaders(includeAuth: false);
    print('No auth headers: $noAuthHeaders');
  }

  /// Example 5: Real-world usage patterns
  static Future<void> realWorldExample() async {
    print('=== Real-world Usage Patterns ===');
    
    // 1. App initialization - get public config
    await _apiClient.getPublic('/app/config', (json) => json);
    
    // 2. User login - no auth required for login itself  
    await _apiClient.postPublicWrapped('/auth/login', (json) => json,
      body: {'email': 'user@example.com', 'password': 'password'});
    
    // 3. Browse products - public access
    await _apiClient.getPublic('/products', (json) => json);
    
    // 4. View cart - requires authentication
    await _apiClient.get('/cart', (json) => json, requireAuth: true);
    
    // 5. Checkout - requires authentication  
    await _apiClient.post('/orders', (json) => json,
      body: {'items': []}, requireAuth: true);
    
    // 6. Logout - requires authentication
    await _apiClient.postSimple('/auth/logout');
    
    print('Real-world flow completed');
  }

  /// Run all examples
  static Future<void> runAllExamples() async {
    await publicEndpointsExample();
    print('');
    await authenticatedEndpointsExample();  
    print('');
    await conditionalAuthExample(true); // Simulate logged in user
    print('');
    await conditionalAuthExample(false); // Simulate guest user
    print('');
    await customHeadersExample();
    print('');
    await realWorldExample();
  }
}