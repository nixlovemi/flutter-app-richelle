# API Configuration Guide

This guide explains how to configure API URLs for different environments in your Flutter app.

## Overview

The app automatically uses different API URLs based on the build mode:

- **Development Mode** (`flutter run`): Uses local development servers
- **Production Mode** (`flutter build`): Uses production servers

## Configuration File

Edit `lib/config/api_config.dart` to set your URLs:

```dart
class ApiConfig {
  // 🔧 UPDATE THESE URLs FOR PRODUCTION
  static const String prodApiUrl = 'https://your-domain.com';
  static const String prodWebUrl = 'https://your-domain.com'; 
  
  // Development URLs (keep these as-is for local development)
  static const String devLocalUrl = 'http://127.0.0.1:8000';
  static const String devAndroidUrl = 'http://10.0.2.2:8000';
  
  // 🔧 UPDATE YOUR API KEY
  static const String apiKey = 'your-production-api-key-here';
}
```

## Environment Behavior

### Development (`flutter run`)
- **Web**: `http://127.0.0.1:8000`
- **Android Emulator**: `http://10.0.2.2:8000` 
- **iOS Simulator**: `http://127.0.0.1:8000`

### Production (`flutter build apk/ios/web`)
- **All Platforms**: Uses your production URLs from config

## Setup Steps

1. **Get your production API URL**
   - Example: `https://api.modariichelle.com`

2. **Update the config file**
   ```dart
   static const String prodApiUrl = 'https://api.modariichelle.com';
   static const String prodWebUrl = 'https://api.modariichelle.com';
   ```

3. **Update your API key**
   ```dart
   static const String apiKey = 'your-actual-production-api-key';
   ```

4. **Test in development**
   ```bash
   flutter run
   ```

5. **Build for production**
   ```bash
   flutter build apk          # Android
   flutter build ios          # iOS  
   flutter build web          # Web
   ```

## Debugging

The app will automatically log which environment and URL it's using:

```
🌐 ApiClient: Environment: Development | Platform: Android | API: http://10.0.2.2:8000/api/v1
```

## Important Notes

- ✅ **HTTPS Required for Production**: Always use HTTPS in production
- ✅ **API Key Security**: Keep your production API key secure
- ✅ **CORS Configuration**: Ensure your production server handles CORS properly
- ✅ **SSL Certificates**: Ensure your production server has valid SSL certificates

## Quick Checklist

- [ ] Update `prodApiUrl` in `api_config.dart`
- [ ] Update `prodWebUrl` in `api_config.dart` 
- [ ] Update `apiKey` in `api_config.dart`
- [ ] Test with `flutter run` (should use dev URLs)
- [ ] Test with `flutter build` (should use prod URLs)
- [ ] Verify production server is accessible
- [ ] Verify CORS and SSL configuration

## Support

If you encounter issues:
1. Check the console logs for the API URL being used
2. Verify your production server is running and accessible
3. Test API endpoints using a tool like Postman
4. Ensure CORS headers are properly configured on your server