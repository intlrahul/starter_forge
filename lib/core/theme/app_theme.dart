import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Define a base font family (optional, but good for consistency)
  // Using Google Fonts package
  static final String? _fontFamily = GoogleFonts.lato().fontFamily;
  // Or, if you have local fonts:
  // static const String _fontFamily = 'YourCustomFontFamily';

  // --- Light Theme ---
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
        backgroundColor:
            Colors.transparent, // Or use colorScheme.surfaceContainer
        foregroundColor: baseLight.colorScheme.onSurface,
        titleTextStyle: GoogleFonts.lato(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: baseLight.colorScheme.onSurface,
        ),
      ),
      textTheme: _textTheme(baseLight.textTheme),
      inputDecorationTheme: _inputDecorationTheme(baseLight.colorScheme),
      elevatedButtonTheme: _elevatedButtonTheme(baseLight.colorScheme),
      cardTheme: _cardTheme(baseLight.colorScheme),
      floatingActionButtonTheme: _floatingActionButtonTheme(
        baseLight.colorScheme,
      ),
      // Add other component themes as needed
    );
  }

  // --- Dark Theme ---
  static ThemeData get darkTheme {
    final baseDark = ThemeData.dark(useMaterial3: true);
    return baseDark.copyWith(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(
          0xFF006CFF,
        ), // Your primary brand color (can be same or different for dark)
        brightness: Brightness.dark,
        primary: const Color(0xFFADC6FF), // Example override for dark primary
        secondary: const Color(0xFFC3C6CF),
        surface: const Color(0xFF1A1C1E), // M3 surface
        error: const Color(0xFFFFB4AB),
      ),
      scaffoldBackgroundColor: const Color(0xFF1A1C1E), // M3 background
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor:
            Colors.transparent, // Or use colorScheme.surfaceContainer
        foregroundColor: baseDark.colorScheme.onSurface,
        titleTextStyle: GoogleFonts.lato(
          // Or _fontFamily
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: baseDark.colorScheme.onSurface,
        ),
      ),
      textTheme: _textTheme(baseDark.textTheme),
      inputDecorationTheme: _inputDecorationTheme(baseDark.colorScheme),
      elevatedButtonTheme: _elevatedButtonTheme(baseDark.colorScheme),
      cardTheme: _cardTheme(baseDark.colorScheme),
      floatingActionButtonTheme: _floatingActionButtonTheme(
        baseDark.colorScheme,
      ),
      // Add other component themes as needed
    );
  }

  // --- Text Theme ---
  static TextTheme _textTheme(TextTheme base) {
    return base
        .copyWith(
          // Headlines
          displayLarge: GoogleFonts.lato(
            textStyle: base.displayLarge,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: GoogleFonts.lato(
            textStyle: base.displayMedium,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: GoogleFonts.lato(
            textStyle: base.displaySmall,
            fontWeight: FontWeight.bold,
          ),
          headlineLarge: GoogleFonts.lato(
            textStyle: base.headlineLarge,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: GoogleFonts.lato(
            textStyle: base.headlineMedium,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: GoogleFonts.lato(
            textStyle: base.headlineSmall,
            fontWeight: FontWeight.w600,
          ),
          // Titles
          titleLarge: GoogleFonts.lato(
            textStyle: base.titleLarge,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: GoogleFonts.lato(
            textStyle: base.titleMedium,
            fontWeight: FontWeight.w500,
          ),
          titleSmall: GoogleFonts.lato(
            textStyle: base.titleSmall,
            fontWeight: FontWeight.w500,
          ),
          // Body
          bodyLarge: GoogleFonts.lato(textStyle: base.bodyLarge),
          bodyMedium: GoogleFonts.lato(textStyle: base.bodyMedium),
          bodySmall: GoogleFonts.lato(textStyle: base.bodySmall),
          // Labels
          labelLarge: GoogleFonts.lato(
            textStyle: base.labelLarge,
            fontWeight: FontWeight.w600,
          ),
          labelMedium: GoogleFonts.lato(
            textStyle: base.labelMedium,
            fontWeight: FontWeight.w500,
          ),
          labelSmall: GoogleFonts.lato(
            textStyle: base.labelSmall,
            fontWeight: FontWeight.w500,
          ),
        )
        .apply(
          fontFamily: _fontFamily, // Apply base font family
        );
  }

  // --- Input Decoration Theme (for TextFields) ---
  static InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.7),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.7),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
      ),
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      hintStyle: TextStyle(
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
      ),
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.5,
      ), // Subtle fill
    );
  }

  // --- ElevatedButton Theme ---
  static ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: GoogleFonts.lato(
          // Or _fontFamily
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
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      color: colorScheme.surface, // Or surfaceContainer for subtle difference
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
