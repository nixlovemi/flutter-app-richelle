# Translation System Documentation

## Overview
The app now supports multiple languages through a centralized translation system built with Brazilian Portuguese as the default language.

## Components

### 1. AppLanguage Enum (`lib/translations/app_language.dart`)
Defines supported languages:
- `AppLanguage.portuguese` - Brazilian Portuguese (default)
- `AppLanguage.english` - English

### 2. AppTranslations (`lib/translations/app_translations.dart`)
Main translation management class with methods:
- `AppTranslations.get('key')` - Get translation for any key
- `AppTranslations.setLanguage(AppLanguage.portuguese)` - Change language
- Helper properties like `AppTranslations.welcome`, `AppTranslations.email`, etc.

### 3. Language Picker Widgets (`lib/widgets/language_picker.dart`)
- `LanguagePicker` - Dropdown with flags and language names
- `LanguageToggleButton` - Simple toggle button (currently used in login)

## Usage Examples

### Basic Translation
```dart
Text(AppTranslations.get('welcome')) // "Bem-vindo!" or "Welcome!"
Text(AppTranslations.welcome)        // Same as above (helper property)
```

### Changing Language
```dart
AppTranslations.setLanguage(AppLanguage.english);
setState(() {}); // Rebuild UI to reflect changes
```

### Alert Dialogs
```dart
AlertDialogUtils.showSimpleAlert(
  context: context,
  title: AppTranslations.get('error'),
  message: AppTranslations.get('loginAttempted') + email,
);
```

### Adding New Translations
1. Add the key to both `_portugueseTranslations` and `_englishTranslations` in `app_translations.dart`
2. Optionally add a helper property to AppTranslations class
3. Use `AppTranslations.get('yourKey')` in your widgets

## Current Brazilian Portuguese Texts
- **Welcome**: "Bem-vindo!"
- **Login Subtitle**: "Faça login e comece sua jornada!"
- **Email**: "E-mail"
- **Password**: "Senha" 
- **Login Button**: "ENTRAR"
- **Sign Up Button**: "CRIAR CONTA"
- **Forgot Password**: "Esqueceu a senha?"
- **Validation Messages**: All in proper Brazilian Portuguese
- **Alert Messages**: Contextual and user-friendly

## Features
✅ Brazilian Portuguese as default language  
✅ English translation support  
✅ Form validation messages translated  
✅ Alert dialogs with translated buttons  
✅ Language toggle button in header  
✅ Extensible system for adding more languages  
✅ Centralized translation management  

## Testing
Use the language toggle button (🌐) in the top-right corner of the login page to switch between Portuguese and English and see all texts update immediately.