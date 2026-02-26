/// Google Sign-In Configuration
/// 
/// Replace these placeholder values with your actual Google OAuth Client IDs
/// from the Google Cloud Console.
/// 
/// To get your Client IDs:
/// 1. Go to Google Cloud Console > APIs & Services > Credentials
/// 2. Find your OAuth 2.0 Client IDs
/// 3. Copy the client IDs for each platform
class GoogleConfig {
  // Replace with your actual Android OAuth Client ID
  static const String androidClientId = '50400870269-2j6oc1j1dcm08rit71gurfpbruhmssnd.apps.googleusercontent.com';
  
  // Replace with your actual iOS OAuth Client ID  
  static const String iosClientId = 'YOUR_IOS_CLIENT_ID_HERE.apps.googleusercontent.com';
  
  // Replace with your actual Web OAuth Client ID (for server-side verification)
  static const String webClientId = '50400870269-i5m63khdh6dd44evrhbi022iu2o5aa78.apps.googleusercontent.com';
  
  /// Your Package Name (make sure this matches your Android app)
  static const String androidPackageName = 'com.richelletimeless.app';
  
  /// Your iOS Bundle ID (make sure this matches your iOS app)
  static const String iosBundleId = 'com.richelletimeless.app';
}