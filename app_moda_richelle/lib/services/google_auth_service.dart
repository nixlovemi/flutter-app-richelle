import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../config/google_config.dart';

/// Service for handling Google Sign-In operations
class GoogleAuthService {
  
  late final GoogleSignIn _googleSignIn;
  
  GoogleAuthService() {
    _initializeGoogleSignIn();
  }

  void _initializeGoogleSignIn() {
    // Configure Google Sign-In based on platform
    String? clientId;
    
    if (defaultTargetPlatform == TargetPlatform.android) {
      clientId = GoogleConfig.androidClientId;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      clientId = GoogleConfig.iosClientId;
    }
    
    _googleSignIn = GoogleSignIn(
      clientId: clientId,
      scopes: [
        'email',
        'profile',
      ],
      // For server-side verification, request an ID token
      serverClientId: GoogleConfig.webClientId,
    );
    
    if (kDebugMode) {
      debugPrint('🔐 GoogleAuth: Initialized with clientId: $clientId');
    }
  }

  /// Sign in with Google and get ID token for server verification
  Future<GoogleSignInResult?> signInWithGoogle() async {
    try {
      if (kDebugMode) {
        debugPrint('🔐 GoogleAuth: Starting Google Sign-In...');
      }

      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      
      if (account == null) {
        if (kDebugMode) {
          debugPrint('🔐 GoogleAuth: User cancelled sign-in');
        }
        return null; // User cancelled the sign-in
      }

      if (kDebugMode) {
        debugPrint('🔐 GoogleAuth: User signed in: ${account.email}');
      }

      // Get authentication details
      final GoogleSignInAuthentication auth = await account.authentication;
      
      if (auth.idToken == null) {
        if (kDebugMode) {
          debugPrint('🔐 GoogleAuth: Failed to get ID token');
        }
        throw Exception('Failed to get Google ID token');
      }

      if (kDebugMode) {
        debugPrint('🔐 GoogleAuth: Got ID token (${auth.idToken!.length} chars)');
      }

      return GoogleSignInResult(
        idToken: auth.idToken!,
        accessToken: auth.accessToken,
        user: GoogleUserInfo(
          id: account.id,
          email: account.email,
          displayName: account.displayName ?? '',
          photoUrl: account.photoUrl,
        ),
      );
    } catch (error) {
      if (kDebugMode) {
        debugPrint('🔐 GoogleAuth: Sign-in error: $error');
      }
      rethrow;
    }
  }

  /// Sign out from Google
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      if (kDebugMode) {
        debugPrint('🔐 GoogleAuth: Signed out successfully');
      }
    } catch (error) {
      if (kDebugMode) {
        debugPrint('🔐 GoogleAuth: Sign-out error: $error');
      }
      rethrow;
    }
  }

  /// Disconnect from Google (revoke access)
  Future<void> disconnect() async {
    try {
      await _googleSignIn.disconnect();
      if (kDebugMode) {
        debugPrint('🔐 GoogleAuth: Disconnected successfully');
      }
    } catch (error) {
      if (kDebugMode) {
        debugPrint('🔐 GoogleAuth: Disconnect error: $error');
      }
      rethrow;
    }
  }

  /// Check if user is currently signed in to Google
  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  /// Get currently signed in Google account (if any)
  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;
}

/// Result from Google Sign-In
class GoogleSignInResult {
  final String idToken;
  final String? accessToken;
  final GoogleUserInfo user;

  GoogleSignInResult({
    required this.idToken,
    this.accessToken,
    required this.user,
  });
}

/// Google user information
class GoogleUserInfo {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;

  GoogleUserInfo({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
  });
}