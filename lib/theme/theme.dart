// theme/theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary colors for the futuristic look
  static const Color primaryColor = Color(0xFF001F54); // Midnight Blue
  static const Color accentColor = Color(0xFF00C8FF); // Neon Cyan
  static const Color secondaryAccent = Color(0xFF8233FF); // Neon Purple
  static const Color textColor = Colors.white; // Bright White

  static const Gradient categoryGradient = LinearGradient(
    colors: [
      Color(0xFF00C8FF), // Neon Cyan
      Color(0xFF8233FF), // Neon Purple
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Light Glow Effect
  static BoxShadow glowEffect = BoxShadow(
    color: const Color(0xFF00C8FF).withOpacity(0.5),
    blurRadius: 8,
    spreadRadius: 3,
  );

  // Themed Button Style for the FAB
  static ButtonStyle futuristicButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: accentColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      shadowColor: Colors.blueAccent,
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
      elevation: 10.0,
    );
  }

  static ThemeData themeData = ThemeData(
    scaffoldBackgroundColor: primaryColor, // Midnight Blue background
    brightness: Brightness.dark, // Dark theme
    primaryColor: primaryColor,
    hintColor: accentColor,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.orbitron(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.rajdhani(
        fontSize: 16,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.rajdhani(
        fontSize: 14,
        color: textColor,
      ),
      labelLarge: GoogleFonts.rajdhani(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    ),
    iconTheme: const IconThemeData(
      color: accentColor, // Neon Cyan for icons
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      elevation: 5,
      foregroundColor: textColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      labelStyle: const TextStyle(color: textColor),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: accentColor),
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      titleTextStyle: GoogleFonts.orbitron(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      iconTheme: const IconThemeData(
        color: accentColor,
      ),
    ),
  );
}
