import '../models/api_error.dart';
import '../translations/app_translations.dart';

/// Service for converting technical errors into user-friendly messages
/// Also handles success and informational messages for consistent UX
/// Centralizes all message logic in one place for better maintainability
/// 
/// Usage patterns:
/// - For API errors: ErrorMessageService.getApiErrorMessage(apiError)
/// - For exceptions: ErrorMessageService.getExceptionMessage(exception)  
/// - For login errors: ErrorMessageService.getLoginErrorMessage(apiError)
/// - For registration errors: ErrorMessageService.getRegistrationErrorMessage(apiError)
/// - For coming soon features: ErrorMessageService.getComingSoonMessage('feature')
/// - For success messages: ErrorMessageService.getProfileSuccessMessage('operation')
/// 
/// Used in conjunction with:
/// - SnackBarUtils for consistent SnackBar styling and behavior
/// - AlertDialogUtils for modal dialogs with consistent styling
/// - AppTranslations for internationalization support
class ErrorMessageService {
  
  /// Convert an API error to a user-friendly message
  static String getApiErrorMessage(ApiError? error) {
    if (error?.message == null) {
      return AppTranslations.get('unexpectedError');
    }
    
    return _convertToUserFriendly(error!.message);
  }
  
  /// Convert an exception to a user-friendly message
  static String getExceptionMessage(Exception exception) {
    return _convertToUserFriendly(exception.toString());
  }
  
  /// Convert a generic error string to a user-friendly message
  static String getErrorMessage(String errorMessage) {
    return _convertToUserFriendly(errorMessage);
  }
  
  /// Convert a raw error message to a user-friendly message
  /// This is the single source of truth for error message conversion
  static String _convertToUserFriendly(String rawMessage) {
    final message = rawMessage.toLowerCase();
    
    // Network and connectivity errors
    if (_containsAny(message, ['timeout', 'tempo', 'timed out'])) {
      return AppTranslations.get('serverTimeout');
    }
    
    if (_containsAny(message, [
      'connection', 'conexão', 'connect', 
      'unavailable', 'indisponível',
      'failed to connect', 'falha na conexão'
    ])) {
      return AppTranslations.get('serverUnavailable');
    }
    
    if (_containsAny(message, ['socket', 'network error', 'erro de rede'])) {
      return AppTranslations.get('connectionFailed');
    }
    
    // Server errors
    if (_containsAny(message, ['server error', 'erro no servidor', 'server'])) {
      return AppTranslations.get('serverError');
    }
    
    // Google Sign-In specific errors
    if (_containsAny(message, ['google sign-in', 'google login'])) {
      // Check for specific Google errors first
      if (_containsAny(message, ['cancelled', 'canceled', 'cancelado'])) {
        return AppTranslations.get('googleSignInCancelled');
      }
      return AppTranslations.get('googleSignInError');
    }
    
    // If no specific pattern matches, return the original message
    // This ensures we don't lose important error details
    return rawMessage;
  }
  
  /// Helper method to check if a string contains any of the given keywords
  static bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }
  
  /// Get a user-friendly message for login failures
  /// Handles both API errors and field-specific errors
  static String getLoginErrorMessage(ApiError? error) {
    if (error == null) {
      return AppTranslations.get('loginFailed');
    }
    
    // Check for specific field errors first
    if (error.errors != null) {
      final emailError = error.getFieldError('email');
      final passwordError = error.getFieldError('password');
      
      if (emailError != null) return emailError;
      if (passwordError != null) return passwordError;
      
      // Return all field errors combined
      return error.allMessages;
    }
    
    // If no field errors, convert the general message
    return getApiErrorMessage(error);
  }
  
  /// Get a user-friendly message for Google login failures
  static String getGoogleLoginErrorMessage(ApiError? error) {
    if (error == null) {
      return AppTranslations.get('googleSignInError');
    }
    
    return getApiErrorMessage(error);
  }
  
  /// Get a user-friendly message for registration failures
  static String getRegistrationErrorMessage(ApiError? error) {
    if (error == null) {
      return AppTranslations.get('registrationFailed');
    }
    
    // Check for specific field errors first
    if (error.errors != null) {
      final emailError = error.getFieldError('email');
      final firstNameError = error.getFieldError('first_name');
      final lastNameError = error.getFieldError('last_name');
      final passwordError = error.getFieldError('password');
      
      if (emailError != null) return emailError;
      if (firstNameError != null) return firstNameError;
      if (lastNameError != null) return lastNameError;
      if (passwordError != null) return passwordError;
      
      // Return all field errors combined
      return error.allMessages;
    }
    
    // If no field errors, convert the general message
    return getApiErrorMessage(error);
  }
  
  // === INFORMATIONAL MESSAGES ===
  
  /// Get standardized "coming soon" messages
  static String getComingSoonMessage(String feature) {
    switch (feature.toLowerCase()) {
      case 'profile':
      case 'profile edit':
      case 'edit profile':
        return AppTranslations.get('profileEditComingSoon');
      case 'password':
      case 'change password':
        return AppTranslations.get('changePasswordComingSoon');
      case 'help':
      case 'support':
      case 'help support':
      case 'help & support':
        return AppTranslations.get('helpSupportComingSoon');
      default:
        return 'Coming soon!'; // Fallback for unknown features
    }
  }
  
  /// Get success messages for profile operations
  static String getProfileSuccessMessage(String operation) {
    switch (operation.toLowerCase()) {
      case 'update':
      case 'updated':
        return AppTranslations.get('profileUpdatedSuccessfully');
      case 'save':
      case 'saved':
        return AppTranslations.get('settingsSaved');
      default:
        return AppTranslations.get('success');
    }
  }
}