import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../translations/app_translations.dart';
import '../translations/app_language.dart';

/// A widget for selecting app language
class LanguagePicker extends StatelessWidget {
  final VoidCallback? onLanguageChanged;
  
  const LanguagePicker({
    super.key,
    this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AppLanguage>(
          value: AppTranslations.currentLanguage,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          borderRadius: BorderRadius.circular(12),
          dropdownColor: AppTheme.white,
          icon: Icon(
            Icons.language,
            color: AppTheme.primary,
          ),
          onChanged: (AppLanguage? newLanguage) {
            if (newLanguage != null) {
              AppTranslations.setLanguage(newLanguage);
              onLanguageChanged?.call();
            }
          },
          items: AppLanguage.values.map<DropdownMenuItem<AppLanguage>>((AppLanguage language) {
            return DropdownMenuItem<AppLanguage>(
              value: language,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getLanguageFlag(language),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    language.displayName,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
  
  String _getLanguageFlag(AppLanguage language) {
    switch (language) {
      case AppLanguage.portuguese:
        return '🇧🇷';
      case AppLanguage.english:
        return '🇺🇸';
    }
  }
}

/// A simple language toggle button
class LanguageToggleButton extends StatelessWidget {
  final VoidCallback? onLanguageChanged;
  
  const LanguageToggleButton({
    super.key,
    this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.language,
          color: AppTheme.primary,
          size: 20,
        ),
      ),
      onPressed: () {
        // Toggle between Portuguese and English
        final currentLang = AppTranslations.currentLanguage;
        final newLang = currentLang == AppLanguage.portuguese 
            ? AppLanguage.english 
            : AppLanguage.portuguese;
        
        AppTranslations.setLanguage(newLang);
        onLanguageChanged?.call();
      },
    );
  }
}