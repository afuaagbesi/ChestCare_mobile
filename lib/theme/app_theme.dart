import 'package:flutter/material.dart';

class AppTheme {
  // Color constants
  static const Color navyBlue = Color(0xFF1A73E8); // Vibrant blue color
  static const Color deepNavy = Color(0xFF0D47A1); // Darker blue color
  static const Color lightBlue = Color(0xFF64B5F6); // Lighter blue for accents
  static const Color accentColor = navyBlue; // Using blue as the primary accent

  // Dark theme colors (blue-black tones)
  static const Color darkBgBlueBlack =
      Color(0xFF121624); // Very dark blue-black
  static const Color darkSurfaceBlueBlack =
      Color(0xFF1E2233); // Slightly lighter blue-black
  static const Color darkCardBlueBlack =
      Color(0xFF252D42); // Blue-black for cards

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: accentColor,
      brightness: Brightness.light,
      primary: accentColor,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: Colors.black87),
    ),
    cardColor: Colors.white,
    dividerColor: Colors.grey.shade200,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: accentColor,
      unselectedItemColor: Colors.grey.shade400,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: accentColor,
      brightness: Brightness.dark,
      primary: accentColor,
      background: darkBgBlueBlack,
      surface: darkSurfaceBlueBlack,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: darkBgBlueBlack,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurfaceBlueBlack,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    cardColor: darkCardBlueBlack,
    dividerColor: const Color(0xFF3A405A),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkSurfaceBlueBlack,
      selectedItemColor: lightBlue,
      unselectedItemColor: Color(0xFF8D8F97),
    ),
  );
}
