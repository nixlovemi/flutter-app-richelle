import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette inspired by the fashion app designs
  static const Color primaryPink = Color(0xFFE91E63);
  static const Color lightPink = Color(0xFFFFE0E6);
  static const Color darkPink = Color(0xFFAD1457);
  static const Color accentRose = Color(0xFFF8BBD9);
  static const Color softPink = Color(0xFFFCE4EC);
  static const Color deepRose = Color(0xFFDA7352);
  static const Color lightRose = Color(0xFFFFE7E7);
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF212121);
  static const Color darkGrey = Color(0xFF424242);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color mediumGrey = Color(0xFF9E9E9E);
  
  // Gradient Colors
  static const List<Color> primaryGradient = [
    lightRose,
    Color.fromARGB(204, 255, 231, 231), // lightRose with 80% opacity
  ];
  
  static const List<Color> backgroundGradient = [
    Color(0xFFFCE4EC),
    Color(0xFFFFE0E6),
  ];
  
  static const List<Color> loginBodyGradient = [
    Color(0xFFf0a4a8),
    Color(0xFFf9bbae),
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

  // Button Styles
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryPink,
    foregroundColor: white,
    elevation: 4,
    shadowColor: primaryPink.withValues(alpha: 0.4),
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
    ),
    textStyle: buttonText,
  );
  
  static ButtonStyle secondaryButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: primaryPink,
    side: const BorderSide(color: primaryPink, width: 2),
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
    ),
    textStyle: buttonText.copyWith(color: primaryPink),
  );
  
  static ButtonStyle socialButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: darkGrey,
    backgroundColor: white,
    side: BorderSide(color: lightGrey, width: 1),
    elevation: 2,
    shadowColor: black.withValues(alpha: 0.1),
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );

  // Input Decoration
  static InputDecoration inputDecoration({
    required String labelText,
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
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: lightGrey, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: lightGrey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: primaryPink, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  // Card Style
  static BoxDecoration cardDecoration = BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: black.withValues(alpha: 0.08),
        blurRadius: 20,
        offset: const Offset(0, 8),
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
        seedColor: primaryPink,
        primary: primaryPink,
        secondary: accentRose,
        surface: lightPink,
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
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: lightGrey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: lightGrey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: primaryPink, width: 2),
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: white,
        elevation: 4,
        shadowColor: black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}