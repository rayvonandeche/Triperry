import 'package:flutter/material.dart';

class AppTheme {
  // Primary colors
  static const Color primaryColor = Color(0xFFFF8C00); // Dark orange
  static const Color secondaryColor = Color(0xFFFFD700); // Gold yellow
  static const Color accentColor = Color(0xFFFFA500); // Orange
  
  // Background colors
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color lightBackground = Color(0xFFF5F5F5);
  
  // Text colors
  static const Color darkText = Color(0xFF333333);
  static const Color lightText = Color(0xFFF5F5F5);
  
  // Surface colors
  static const Color darkSurface = Color(0xFF2A2A2A);
  static const Color lightSurface = Color(0xFFFFFFFF);
  
  // Error color
  static const Color errorColor = Color(0xFFE57373);
  
  // Success color
  static const Color successColor = Color(0xFF81C784);
  
  // Warning color
  static const Color warningColor = Color(0xFFFFB74D);
  
  // Info color
  static const Color infoColor = Color(0xFF64B5F6);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: lightSurface,
        background: lightBackground,
        error: errorColor,
      ),
      scaffoldBackgroundColor: lightBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: lightSurface,
        foregroundColor: darkText,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: darkText),
        titleTextStyle: const TextStyle(
          color: darkText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightSurface,
        selectedItemColor: primaryColor,
        unselectedItemColor: darkText.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: lightText,
      ),
      cardTheme: CardTheme(
        color: lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: darkText),
        displayMedium: TextStyle(color: darkText),
        displaySmall: TextStyle(color: darkText),
        headlineLarge: TextStyle(color: darkText),
        headlineMedium: TextStyle(color: darkText),
        headlineSmall: TextStyle(color: darkText),
        titleLarge: TextStyle(color: darkText),
        titleMedium: TextStyle(color: darkText),
        titleSmall: TextStyle(color: darkText),
        bodyLarge: TextStyle(color: darkText),
        bodyMedium: TextStyle(color: darkText),
        bodySmall: TextStyle(color: darkText),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: darkSurface,
        background: darkBackground,
        error: errorColor,
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: lightText,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: lightText),
        titleTextStyle: const TextStyle(
          color: lightText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: primaryColor,
        unselectedItemColor: lightText.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: lightText,
      ),
      cardTheme: CardTheme(
        color: darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: lightText),
        displayMedium: TextStyle(color: lightText),
        displaySmall: TextStyle(color: lightText),
        headlineLarge: TextStyle(color: lightText),
        headlineMedium: TextStyle(color: lightText),
        headlineSmall: TextStyle(color: lightText),
        titleLarge: TextStyle(color: lightText),
        titleMedium: TextStyle(color: lightText),
        titleSmall: TextStyle(color: lightText),
        bodyLarge: TextStyle(color: lightText),
        bodyMedium: TextStyle(color: lightText),
        bodySmall: TextStyle(color: lightText),
      ),
    );
  }
} 