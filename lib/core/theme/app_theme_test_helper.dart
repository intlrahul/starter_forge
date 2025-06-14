import 'package:flutter/material.dart';
import 'package:starter_forge/core/theme/app_theme.dart';

/// This class provides test helpers to mock AppTheme for testing
class AppThemeTestHelper {
  /// Creates a test-friendly version of light theme that doesn't rely on Google Fonts
  static ThemeData get lightTheme {
    final baseLight = ThemeData.light(useMaterial3: true);
    return baseLight.copyWith(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF006CFF), // Your primary brand color
        brightness: Brightness.light,
        // You can override specific colors further if needed:
        primary: const Color(0xFF006CFF),
        secondary: const Color(0xFF5A5F71),
        surface: const Color(0xFFFDFBFF), // M3 surface
        error: const Color(0xFFBA1A1A),
      ),
      scaffoldBackgroundColor: const Color(0xFFFDFBFF), // M3 background
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: baseLight.colorScheme.onSurface,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: baseLight.colorScheme.onSurface,
        ),
      ),
      inputDecorationTheme: _inputDecorationTheme(baseLight.colorScheme),
      elevatedButtonTheme: _elevatedButtonTheme(baseLight.colorScheme),
      cardTheme: _cardTheme(baseLight.colorScheme),
      floatingActionButtonTheme: _floatingActionButtonTheme(
        baseLight.colorScheme,
      ),
    );
  }

  /// Creates a test-friendly version of dark theme that doesn't rely on Google Fonts
  static ThemeData get darkTheme {
    final baseDark = ThemeData.dark(useMaterial3: true);
    return baseDark.copyWith(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF006CFF),
        brightness: Brightness.dark,
        primary: const Color(0xFFADC6FF),
        secondary: const Color(0xFFC3C6CF),
        surface: const Color(0xFF1A1C1E),
        error: const Color(0xFFFFB4AB),
      ),
      scaffoldBackgroundColor: const Color(0xFF1A1C1E),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: baseDark.colorScheme.onSurface,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: baseDark.colorScheme.onSurface,
        ),
      ),
      inputDecorationTheme: _inputDecorationTheme(baseDark.colorScheme),
      elevatedButtonTheme: _elevatedButtonTheme(baseDark.colorScheme),
      cardTheme: _cardTheme(baseDark.colorScheme),
      floatingActionButtonTheme: _floatingActionButtonTheme(
        baseDark.colorScheme,
      ),
    );
  }

  // --- Input Decoration Theme (for TextFields) ---
  static InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: colorScheme.outline.withOpacity(0.7),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: colorScheme.outline.withOpacity(0.7),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
      ),
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      hintStyle: TextStyle(
        color: colorScheme.onSurfaceVariant.withOpacity(0.7),
      ),
      filled: true,
      fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
    );
  }

  // --- ElevatedButton Theme ---
  static ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 1.0,
      ),
    );
  }

  // --- Card Theme ---
  static CardThemeData _cardTheme(ColorScheme colorScheme) {
    return CardThemeData(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      color: colorScheme.surface,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
    );
  }

  // --- FloatingActionButton Theme ---
  static FloatingActionButtonThemeData _floatingActionButtonTheme(
    ColorScheme colorScheme,
  ) {
    return FloatingActionButtonThemeData(
      elevation: 1.0,
      backgroundColor: colorScheme.tertiaryContainer,
      foregroundColor: colorScheme.onTertiaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}