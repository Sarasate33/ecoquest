// lib/config/theme.dart

import 'package:flutter/material.dart';

// Colors
const Color ecoPrimaryGreen = Color(0xFF246024);
const Color ecoFreshOrange = Color(0xFFFFAE00);
const Color ecoSoftSage = Color(0xFFB3C3A5);
const Color ecoBackgroundWhite = Color(0xFFFFFFFF);
const Color ecoGrey = Color(0xFFD9D9D9);
const Color ecoTextBlack = Colors.black;

// Fonts
const String fontTitle = 'Inter';
const String fontBody = 'Merriweather';

// Theme
ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: ecoPrimaryGreen,
    secondary: ecoFreshOrange,
  );

  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      titleTextStyle: const TextStyle(
        fontFamily: fontTitle,
        fontWeight: FontWeight.w700,
        fontSize: 20,
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

    // Inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF2F2F2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(fontFamily: fontBody, fontSize: 14),
    ),

    // Text
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: fontTitle,
        fontWeight: FontWeight.w700,
        fontSize: 32,
      ),
      titleLarge: TextStyle(
        fontFamily: fontTitle,
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
      titleMedium: TextStyle(
        fontFamily: fontTitle,
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontBody,
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontBody,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        fontFamily: fontBody,
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ),
    ),
  );
}
