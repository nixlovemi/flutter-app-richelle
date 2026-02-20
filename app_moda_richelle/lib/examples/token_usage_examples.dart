/// 
/// COMPREHENSIVE GUIDE: How to Use Authentication Tokens in Your App
/// 
/// This file demonstrates all the different ways you can retrieve and use 
/// authentication tokens for API calls throughout your Flutter app.
///

import '../services/api_client.dart';
import '../services/user_api_service.dart';
import '../utils/auth_utils.dart';

class TokenUsageExamples {
  
  /// METHOD 1: Using AuthUtils (Recommended for most cases)
  /// This is the easiest way to get tokens in widgets or services
  static Future<void> exampleUsingAuthUtils() async {
    print('=== Method 1: Using AuthUtils ===');
    
    // Get the current token
    final token = await AuthUtils.getToken();
    print('Token: ${token ?? 'Not authenticated'}');
    
    // Get complete auth headers for API requests
    final headers = await AuthUtils.getAuthHeaders();
    print('Headers: $headers');
    
    // Check if user is authenticated
    final isAuth = await AuthUtils.isAuthenticated();
    print('Authenticated: $isAuth');
    
    // Get just the authorization header value
    final authHeader = await AuthUtils.getAuthorizationHeader();
    print('Auth Header: ${authHeader ?? 'None'}');
  }

  /// METHOD 2: Using ApiClient directly
  /// Good when you need access to the ApiClient instance
  static Future<void> exampleUsingApiClient() async {
    print('=== Method 2: Using ApiClient ===');
    
    // Get shared ApiClient instance
    final apiClient = ApiClient.instance;
    
    // Get current token from memory (fast)
    String? token = apiClient.authToken;
    print('Token from memory: ${token ?? 'Not in memory'}');
    
    // Get token from secure storage (more reliable)
    token = await ApiClient.getCurrentToken();
    print('Token from storage: ${token ?? 'Not authenticated'}');
    
    // Check authentication status
    final isAuth = await ApiClient.isAuthenticated();
    print('Authenticated: $isAuth');
    
    // Get headers for external HTTP clients
    final headers = await ApiClient.getAuthHeaders();
    print('Headers: $headers');
  }

  /// METHOD 3: Creating API Services (Best Practice)
  /// This is how you should create other API services in your app
  static Future<void> exampleCreatingApiServices() async {
    print('=== Method 3: Creating API Services ===');
    
    // Create a user API service
    final userService = UserApiService();
    
    // All methods automatically use authentication
    final profileResponse = await userService.getUserProfile();
    
    if (profileResponse.isSuccess) {
      print('Profile loaded successfully');
    } else {
      print('Profile failed: ${profileResponse.error?.message}');
    }
    
    // You can also access token utilities from any service
    final token = await userService.getCurrentToken();
    print('Token from service: ${token ?? 'Not authenticated'}');
  }

  /// METHOD 4: Custom HTTP Client Usage
  /// When you need to use a different HTTP client (like Dio)
  static Future<void> exampleCustomHttpClient() async {
    print('=== Method 4: Custom HTTP Client ===');
    
    // Get headers for use with any HTTP client
    final headers = await AuthUtils.getAuthHeaders();
    
    // Example with standard http package:
    /*
    import 'package:http/http.dart' as http;
    
    final response = await http.get(
      Uri.parse('${AuthUtils.apiBaseUrl}/custom-endpoint'),
      headers: headers,
    );
    */
    
    print('Headers ready for custom HTTP client: $headers');
  }

  /// METHOD 5: Widget Usage
  /// How to use authentication in your Flutter widgets
  static Future<void> exampleWidgetUsage() async {
    print('=== Method 5: Widget Usage ===');
    
    // In a widget's initState or method:
    /*
    class MyWidget extends StatefulWidget {
      @override
      void initState() {
        super.initState();
        checkAuthAndLoadData();
      }
      
      Future<void> checkAuthAndLoadData() async {
        final isAuth = await AuthUtils.isAuthenticated();
        
        if (isAuth) {
          // User is authenticated, load data
          final headers = await AuthUtils.getAuthHeaders();
          // Make API call with headers
        } else {
          // Redirect to login
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    }
    */
    
    print('See comments in code for widget usage example');
  }

  /// METHOD 6: WebSocket or Real-time Connections
  /// How to use tokens for WebSocket authentication
  static Future<void> exampleWebSocketUsage() async {
    print('=== Method 6: WebSocket Usage ===');
    
    // Get token for WebSocket connection
    final token = await AuthUtils.getTokenForWebSocket();
    
    // Example WebSocket connection:
    /*
    import 'package:web_socket_channel/web_socket_channel.dart';
    
    final wsUrl = 'ws://127.0.0.1:8000/ws?token=$token';
    final channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    */
    
    print('Token ready for WebSocket: ${token.isNotEmpty ? 'Available' : 'Not available'}');
  }

  /// METHOD 7: Debugging Authentication
  /// Helper methods for debugging auth issues
  static Future<void> exampleDebugging() async {
    print('=== Method 7: Debugging ===');
    
    // Print comprehensive auth status
    await AuthUtils.debugAuthStatus();
    
    // Check specific components
    final tokenFromMemory = ApiClient.instance.authToken;
    final tokenFromStorage = await AuthUtils.getToken();
    
    print('Token in memory: ${tokenFromMemory != null}');
    print('Token in storage: ${tokenFromStorage != null}');
    print('Tokens match: ${tokenFromMemory == tokenFromStorage}');
  }

  /// RUN ALL EXAMPLES
  /// Call this method to see all examples in action
  static Future<void> runAllExamples() async {
    await exampleUsingAuthUtils();
    print('');
    await exampleUsingApiClient();
    print('');
    await exampleCreatingApiServices();
    print('');
    await exampleCustomHttpClient();
    print('');
    await exampleWidgetUsage();
    print('');
    await exampleWebSocketUsage();
    print('');
    await exampleDebugging();
  }
}

/// SUMMARY: Choose the right method for your use case
/// 
/// 1. **AuthUtils.getToken()** - Quick token access in widgets/services ✅ 
/// 2. **AuthUtils.getAuthHeaders()** - Complete headers for HTTP clients ✅
/// 3. **Extend BaseApiService** - For creating new API service classes ✅
/// 4. **ApiClient.getCurrentToken()** - Direct access to ApiClient ✅
/// 
/// All methods automatically handle:
/// - Secure storage retrieval
/// - Memory caching for performance  
/// - Proper header formatting
/// - Authentication state checking
///