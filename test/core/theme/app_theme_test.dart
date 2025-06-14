import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_forge/core/theme/app_theme_test_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Initialize Flutter binding for tests

  group('AppTheme', () {
    test('lightTheme has correct brightness', () {
      expect(AppThemeTestHelper.lightTheme.brightness, equals(Brightness.light));
    });

    test('darkTheme has correct brightness', () {
      expect(AppThemeTestHelper.darkTheme.brightness, equals(Brightness.dark));
    });

    test('lightTheme has correct color scheme', () {
      final colorScheme = AppThemeTestHelper.lightTheme.colorScheme;
      expect(colorScheme.primary, equals(const Color(0xFF006CFF)));
      expect(colorScheme.secondary, equals(const Color(0xFF5A5F71)));
      expect(colorScheme.surface, equals(const Color(0xFFFDFBFF)));
      expect(colorScheme.error, equals(const Color(0xFFBA1A1A)));
    });

    test('darkTheme has correct color scheme', () {
      final colorScheme = AppThemeTestHelper.darkTheme.colorScheme;
      expect(colorScheme.primary, equals(const Color(0xFFADC6FF)));
      expect(colorScheme.secondary, equals(const Color(0xFFC3C6CF)));
      expect(colorScheme.surface, equals(const Color(0xFF1A1C1E)));
      expect(colorScheme.error, equals(const Color(0xFFFFB4AB)));
    });

    test('lightTheme has correct scaffold background color', () {
      expect(
        AppThemeTestHelper.lightTheme.scaffoldBackgroundColor,
        equals(const Color(0xFFFDFBFF)),
      );
    });

    test('darkTheme has correct scaffold background color', () {
      expect(
        AppThemeTestHelper.darkTheme.scaffoldBackgroundColor,
        equals(const Color(0xFF1A1C1E)),
      );
    });

    test('lightTheme has correct app bar theme', () {
      final appBarTheme = AppThemeTestHelper.lightTheme.appBarTheme;
      expect(appBarTheme.elevation, equals(0));
      expect(appBarTheme.backgroundColor, equals(Colors.transparent));
      expect(appBarTheme.titleTextStyle?.fontSize, equals(20));
      expect(appBarTheme.titleTextStyle?.fontWeight, equals(FontWeight.w600));
    });

    test('darkTheme has correct app bar theme', () {
      final appBarTheme = AppThemeTestHelper.darkTheme.appBarTheme;
      expect(appBarTheme.elevation, equals(0));
      expect(appBarTheme.backgroundColor, equals(Colors.transparent));
      expect(appBarTheme.titleTextStyle?.fontSize, equals(20));
      expect(appBarTheme.titleTextStyle?.fontWeight, equals(FontWeight.w600));
    });

    test('lightTheme has correct input decoration theme', () {
      final inputTheme = AppThemeTestHelper.lightTheme.inputDecorationTheme;
      expect(inputTheme.border, isA<OutlineInputBorder>());
      expect(inputTheme.enabledBorder, isA<OutlineInputBorder>());
      expect(inputTheme.focusedBorder, isA<OutlineInputBorder>());
      expect(inputTheme.filled, isTrue);
    });

    test('darkTheme has correct input decoration theme', () {
      final inputTheme = AppThemeTestHelper.darkTheme.inputDecorationTheme;
      expect(inputTheme.border, isA<OutlineInputBorder>());
      expect(inputTheme.enabledBorder, isA<OutlineInputBorder>());
      expect(inputTheme.focusedBorder, isA<OutlineInputBorder>());
      expect(inputTheme.filled, isTrue);
    });

    test('lightTheme has correct elevated button theme', () {
      final buttonTheme = AppThemeTestHelper.lightTheme.elevatedButtonTheme;
      expect(buttonTheme.style?.backgroundColor?.resolve({}), isNotNull);
      expect(buttonTheme.style?.foregroundColor?.resolve({}), isNotNull);
      expect(buttonTheme.style?.padding?.resolve({}), equals(const EdgeInsets.symmetric(horizontal: 24, vertical: 14)));
      expect(buttonTheme.style?.elevation?.resolve({}), equals(1.0));
    });

    test('darkTheme has correct elevated button theme', () {
      final buttonTheme = AppThemeTestHelper.darkTheme.elevatedButtonTheme;
      expect(buttonTheme.style?.backgroundColor?.resolve({}), isNotNull);
      expect(buttonTheme.style?.foregroundColor?.resolve({}), isNotNull);
      expect(buttonTheme.style?.padding?.resolve({}), equals(const EdgeInsets.symmetric(horizontal: 24, vertical: 14)));
      expect(buttonTheme.style?.elevation?.resolve({}), equals(1.0));
    });

    test('lightTheme has correct card theme', () {
      final cardTheme = AppThemeTestHelper.lightTheme.cardTheme;
      expect(cardTheme.elevation, equals(0.5));
      expect(cardTheme.margin, equals(const EdgeInsets.symmetric(vertical: 8.0)));
    });

    test('darkTheme has correct card theme', () {
      final cardTheme = AppThemeTestHelper.darkTheme.cardTheme;
      expect(cardTheme.elevation, equals(0.5));
      expect(cardTheme.margin, equals(const EdgeInsets.symmetric(vertical: 8.0)));
    });

    test('lightTheme has correct floating action button theme', () {
      final fabTheme = AppThemeTestHelper.lightTheme.floatingActionButtonTheme;
      expect(fabTheme.elevation, equals(1.0));
      expect(fabTheme.backgroundColor, isNotNull);
      expect(fabTheme.foregroundColor, isNotNull);
    });

    test('darkTheme has correct floating action button theme', () {
      final fabTheme = AppThemeTestHelper.darkTheme.floatingActionButtonTheme;
      expect(fabTheme.elevation, equals(1.0));
      expect(fabTheme.backgroundColor, isNotNull);
      expect(fabTheme.foregroundColor, isNotNull);
    });
  });
} 