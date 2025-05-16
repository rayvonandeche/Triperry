import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary colors
  static const Color primaryColor = Color.fromARGB(255, 104, 57, 0); // Dark orange
  static const Color secondaryColor = Color.fromARGB(255, 180, 99, 0); // Gold yellow
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

  // UI Enhancement Constants
  static const BorderRadius defaultBorderRadius = BorderRadius.all(Radius.circular(12));
  static const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(16));
  static const BorderRadius buttonBorderRadius = BorderRadius.all(Radius.circular(24));

  // Border styles
  static BoxBorder lightBorder = Border.all(
    color: Colors.white.withOpacity(0.12),
    width: 0.8,
  );

  static BoxBorder darkBorder = Border.all(
    color: Colors.black.withOpacity(0.04),
    width: 0.8,
  );

  // Widget Decorations
  static BoxDecoration getGradientCardDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          isDark 
              ? Colors.white.withOpacity(0.05) 
              : Colors.white.withOpacity(0.7),
          isDark 
              ? Colors.white.withOpacity(0.02) 
              : Colors.white.withOpacity(0.9),
        ],
      ),
      borderRadius: cardBorderRadius,
      border: isDark ? lightBorder : darkBorder,
      boxShadow: [
        BoxShadow(
          color: isDark 
              ? Colors.black.withOpacity(0.2) 
              : Colors.black.withOpacity(0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ],
    );
  }

  static BoxDecoration getSubtleGradientDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryColor.withOpacity(isDark ? 0.2 : 0.1),
          primaryColor.withOpacity(isDark ? 0.05 : 0.03),
        ],
      ),
      borderRadius: defaultBorderRadius,
      border: Border.all(
        color: primaryColor.withOpacity(isDark ? 0.2 : 0.1),
        width: 0.8,
      ),
    );
  }

  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.nunitoTextTheme(ThemeData.light().textTheme);
    
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
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: darkText,
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
      textTheme: textTheme,
    );
  }

  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme);
    
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
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: lightText,
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
      textTheme: textTheme,
    );
  }
}