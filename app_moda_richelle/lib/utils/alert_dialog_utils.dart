import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../translations/app_translations.dart';

class AlertDialogUtils {
  /// Shows a customizable alert dialog
  /// 
  /// [context] - Build context for showing the dialog
  /// [title] - Title text for the dialog
  /// [message] - Main content message
  /// [actions] - Optional list of dialog actions. If null, shows default OK button
  static Future<void> showCustomAlert({
    required BuildContext context,
    required String title,
    required String message,
    List<Widget>? actions,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            title,
            style: AppTheme.headingSmall,
          ),
          content: Text(
            message,
            style: AppTheme.bodyMedium,
          ),
          actions: actions ?? [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primary,
              ),
              child: Text(
                AppTranslations.ok,
                style: AppTheme.buttonText.copyWith(
                  color: AppTheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Shows a simple alert with just title and message (uses default OK button)
  static Future<void> showSimpleAlert({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    return showCustomAlert(
      context: context,
      title: title,
      message: message,
    );
  }

  /// Shows a confirmation dialog with Yes/No buttons
  /// Returns true if user selects Yes, false if No, null if dismissed
  static Future<bool?> showConfirmationAlert({
    required BuildContext context,
    required String title,
    required String message,
    String? yesText,
    String? noText,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            title,
            style: AppTheme.headingSmall,
          ),
          content: Text(
            message,
            style: AppTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.mediumGrey,
              ),
              child: Text(
                noText ?? AppTranslations.no,
                style: AppTheme.buttonText.copyWith(
                  color: AppTheme.mediumGrey,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primary,
              ),
              child: Text(
                yesText ?? AppTranslations.yes,
                style: AppTheme.buttonText.copyWith(
                  color: AppTheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}