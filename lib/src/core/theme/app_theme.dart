import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors from Tailwind Config
  static const Color primary = Color(0xFF702F8A); // Deep Purple
  static const Color secondary = Color(0xFFF0366B); // Pink
  static const Color accent = Color(0xFFF6B022); // Golden Yellow
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF121212); // Very dark grey
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E); // Dark grey for cards
  static const Color surfaceDarkHighlight = Color(0xFF2C2C2C); // Inputs

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surfaceDark,
        background: backgroundDark,
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      textTheme: TextTheme(
        // Display Font: Montserrat
        displayLarge: GoogleFonts.montserrat(fontWeight: FontWeight.w900, color: Colors.white),
        displayMedium: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: Colors.white),
        displaySmall: GoogleFonts.montserrat(fontWeight: FontWeight.w600, color: Colors.white),
        // Body Font: Inter
        bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey[100]),
        bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey[300]),
        labelLarge: GoogleFonts.inter(fontWeight: FontWeight.bold), // Buttons
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDarkHighlight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // Rounded full
          borderSide: BorderSide.none,
        ),
        hintStyle: GoogleFonts.inter(color: Colors.grey[500], fontSize: 14),
        prefixIconColor: primary,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
