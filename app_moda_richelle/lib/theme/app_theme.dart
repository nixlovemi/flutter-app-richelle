import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette - Semantic color names for easy theme changes
  static const Color primary = Color(0xFF231201);      // Main brand color
  static const Color surfaceLight = Color(0xFFEDEAE7);  // Light background
  static const Color primaryDark = Color(0xFF1A0D01);   // Dark variant of primary
  static const Color secondary = Color(0xFFC4B59A);     // Secondary accent
  static const Color surfaceSoft = Color(0xFFF2EFEC);   // Soft background
  static const Color tertiary = Color(0xFF8B7B6B);     // Tertiary color
  static const Color surface = Color(0xFFE8E3DD);      // General surface color
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF212121);
  static const Color darkGrey = Color(0xFF424242);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color mediumGrey = Color(0xFF9E9E9E);
  
  // Gradient Colors
  static const List<Color> primaryGradient = [
    surface,
    Color.fromARGB(204, 232, 227, 221), // surface with 80% opacity
  ];
  
  static const List<Color> backgroundGradient = [
    surfaceSoft,
    surfaceLight,
  ];
  
  static const List<Color> loginBodyGradient = [
    secondary,
    tertiary,
  ];

  // Typography
  static const String fontFamily = 'Roboto';
  static const double sidePadding = 32;
  
  static const TextStyle headingLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: black,
    letterSpacing: -0.5,
  );
  
  static const TextStyle headingMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: black,
    letterSpacing: -0.3,
  );
  
  static const TextStyle headingSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: black,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: black,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: darkGrey,
    height: 1.4,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: white,
    letterSpacing: 0.5,
  );
  
  static const TextStyle labelText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: mediumGrey,
  );
  
  static const TextStyle whiteLabelText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: white,
  );

  // Button Styles
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: white,
    foregroundColor: black,
    elevation: 0,
    shadowColor: Colors.transparent,
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    textStyle: buttonText.copyWith(color: white),
  );
  
  static ButtonStyle secondaryButtonStyle = OutlinedButton.styleFrom(
    backgroundColor: white,
    foregroundColor: black,
    side: const BorderSide(color: white, width: 2),
    elevation: 0,
    shadowColor: Colors.transparent,
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    textStyle: buttonText.copyWith(color: black),
  );
  
  static ButtonStyle socialButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: darkGrey,
    backgroundColor: white,
    side: BorderSide(color: lightGrey, width: 1),
    elevation: 0,
    shadowColor: Colors.transparent,
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  );

  // Input Decoration
  static InputDecoration inputDecoration({
    String? labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      labelStyle: AppTheme.labelText.copyWith(color: mediumGrey),
      hintStyle: bodyMedium.copyWith(color: mediumGrey),
      filled: true,
      fillColor: white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: lightGrey, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: lightGrey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
  
  // Input Decoration with shadow
  static BoxDecoration inputShadowDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: black.withValues(alpha: 0.3),
        blurRadius: 1,
        offset: const Offset(0, 3),
      ),
    ],
  );
  
  // Button Shadow Decoration
  static BoxDecoration buttonShadowDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: black.withValues(alpha: 0.3),
        blurRadius: 1,
        offset: const Offset(0, 3),
      ),
    ],
  );
  
  // Header Shadow Decoration
  static BoxDecoration headerShadowDecoration = BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: black.withValues(alpha: 0.3),
        blurRadius: 1,
        offset: const Offset(0, 3),
      ),
    ],
  );
  
  // Social Media Button Configuration
  static const double socialButtonSize = 40;
  static const double socialButtonBorderRadius = 15;
  static const double socialButtonIconSize = 24;
  
  static BoxDecoration socialButtonDecoration = BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(socialButtonBorderRadius),
    boxShadow: [
      BoxShadow(
        color: black.withValues(alpha: 0.3),
        blurRadius: 1,
        offset: const Offset(0, 3),
      ),
    ],
  );

  // Card Style
  static BoxDecoration cardDecoration = BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: black.withValues(alpha: 0.3),
        blurRadius: 1,
        offset: const Offset(0, 3),
      ),
    ],
  );

  // Gradient Decorations
  static BoxDecoration primaryGradientDecoration = const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: primaryGradient,
    ),
  );
  
  static BoxDecoration backgroundGradientDecoration = const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: backgroundGradient,
    ),
  );
  
  static BoxDecoration loginBodyGradientDecoration = const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: loginBodyGradient,
    ),
  );

  // App Theme Data
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        surface: surfaceLight,
        error: Colors.red,
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: headingLarge,
        displayMedium: headingMedium,
        displaySmall: headingSmall,
        headlineMedium: headingMedium,
        headlineSmall: headingSmall,
        titleLarge: headingMedium,
        titleMedium: headingSmall,
        titleSmall: bodyLarge,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        labelLarge: buttonText,
        labelMedium: labelText,
      ),
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: headingMedium.copyWith(color: black),
        iconTheme: const IconThemeData(color: black),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: primaryButtonStyle,
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: secondaryButtonStyle,
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: lightGrey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: lightGrey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: primary, width: 2),
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}