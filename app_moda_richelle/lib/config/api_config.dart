import 'package:flutter/foundation.dart';

/// API Configuration for different environments
class ApiConfig {
  // Production API URLs
  static const String prodApiUrl = 'https://your-domain.com'; // TODO: Update with your production API URL
  static const String prodWebUrl = 'https://your-domain.com'; // TODO: Update with your production web URL
  
  // Development API URLs
  static const String devLocalUrl = 'http://127.0.0.1:8000';
  static const String devAndroidUrl = 'http://10.0.2.2:8000';
  
  // API Configuration
  static const String apiPrefix = '/api/v1';
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // Headers
  static const String apiKey = 'da39a3ee5e6b4b0d3255bfef95601890afd80709'; // TODO: Update with your API key
  
  /// Get base URL based on current environment and platform
  static String get baseUrl {
    if (kReleaseMode) {
      // Production environment
      return kIsWeb ? prodWebUrl : prodApiUrl;
    } else {
      // Development environment
      if (kIsWeb) {
        return devLocalUrl;
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        return devAndroidUrl;
      } else {
        return devLocalUrl;
      }
    }
  }
  
  /// Get full API URL with prefix
  static String get fullApiUrl => '$baseUrl$apiPrefix';
  
  /// Get current environment name
  static String get environmentName => kReleaseMode ? 'Production' : 'Development';
  
  /// Get current platform name
  static String get platformName {
    if (kIsWeb) return 'Web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'Android';
      case TargetPlatform.iOS:
        return 'iOS';
      case TargetPlatform.windows:
        return 'Windows';
      case TargetPlatform.macOS:
        return 'macOS';
      case TargetPlatform.linux:
        return 'Linux';
      default:
        return 'Unknown';
    }
  }
  
  /// Get environment info string for debugging
  static String get environmentInfo {
    return 'Environment: $environmentName | Platform: $platformName | API: $fullApiUrl';
  }
  
  /// Check if running in production
  static bool get isProduction => kReleaseMode;
  
  /// Check if running in development
  static bool get isDevelopment => kDebugMode;
}