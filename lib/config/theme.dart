// lib/config/theme.dart

import 'package:flutter/material.dart';

// Farben
const Color ecoPrimaryGreen = Color(0xFF246024);
const Color ecoFreshOrange = Color(0xFFFFAE00);
const Color ecoSoftSage = Color(0xFFB3C3A5);
const Color ecoBackgroundWhite = Color(0xFFFFFFFF);
const Color ecoGrey = Color(0xFFD9D9D9);
const Color ecoTextBlack = Colors.black;

// Schriftarten
const String fontTitle = 'Inter';
const String fontBody = 'Merriweather';

// Theme
ThemeData buildAppTheme() {
  return ThemeData(
    primaryColor: ecoPrimaryGreen,
    scaffoldBackgroundColor: ecoBackgroundWhite,
    useMaterial3: true,
    
    // Farbschema
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: ecoPrimaryGreen,
      secondary: ecoFreshOrange,
      tertiary: ecoSoftSage,
      surface: ecoBackgroundWhite,
      onSurface: ecoTextBlack,
    ),
    
    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: ecoBackgroundWhite,
      foregroundColor: ecoTextBlack,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: fontTitle,
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: ecoTextBlack,
      ),
    ),
    
    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ecoPrimaryGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontFamily: fontTitle,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    ),
    
    // Input Fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF2F2F2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(
        fontFamily: fontBody,
        fontSize: 14,
      ),
    ),
    
    // Text Theme
    textTheme: const TextTheme(
      // Titel
      headlineLarge: TextStyle(
        fontFamily: fontTitle,
        fontWeight: FontWeight.w700,
        fontSize: 32,
        color: ecoTextBlack,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontTitle,
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: ecoTextBlack,
      ),
      headlineSmall: TextStyle(
        fontFamily: fontTitle,
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: ecoTextBlack,
      ),
      titleLarge: TextStyle(
        fontFamily: fontTitle,
        fontWeight: FontWeight.w700,
        fontSize: 18,
        color: ecoTextBlack,
      ),
      titleMedium: TextStyle(
        fontFamily: fontTitle,
        fontWeight: FontWeight.w700,
        fontSize: 16,
        color: ecoTextBlack,
      ),
      
      // Body Text
      bodyLarge: TextStyle(
        fontFamily: fontBody,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: ecoTextBlack,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontBody,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: ecoTextBlack,
      ),
      bodySmall: TextStyle(
        fontFamily: fontBody,
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: ecoTextBlack,
      ),
      
      // Labels
      labelLarge: TextStyle(
        fontFamily: fontTitle,
        fontWeight: FontWeight.w700,
        fontSize: 14,
        color: ecoTextBlack,
      ),
    ),
  );
}