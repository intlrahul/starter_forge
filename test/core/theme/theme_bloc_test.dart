import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_forge/core/theme/theme_bloc/theme_bloc.dart';
import 'package:starter_forge/core/theme/theme_bloc/theme_event.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Initialize Flutter binding for tests

  late ThemeBloc themeBloc;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    themeBloc = ThemeBloc();
  });

  tearDown(() {
    themeBloc.close();
  });

  group('ThemeBloc', () {
    test('initial state is correct', () {
      expect(themeBloc.state.themeMode, equals(ThemeMode.system));
      expect(themeBloc.state.isDarkMode, equals(false));
    });

    test(
      'LoadTheme event loads system theme when no preference is set',
      () async {
        await prefs.remove('appThemeModeBloc');
        themeBloc.add(LoadTheme());

        // Allow the bloc to process the event
        await Future.delayed(const Duration(milliseconds: 100));

        expect(themeBloc.state.themeMode, equals(ThemeMode.system));
      },
    );

    test('UpdateTheme event updates to light theme', () async {
      themeBloc.add(const UpdateTheme(ThemeMode.light));

      // Allow the bloc to process the event
      await Future.delayed(const Duration(milliseconds: 100));

      expect(themeBloc.state.themeMode, equals(ThemeMode.light));
      expect(themeBloc.state.isDarkMode, equals(false));
      expect(prefs.getString('appThemeModeBloc'), equals('light'));
    });

    test('UpdateTheme event updates to dark theme', () async {
      themeBloc.add(const UpdateTheme(ThemeMode.dark));

      // Allow the bloc to process the event
      await Future.delayed(const Duration(milliseconds: 100));

      expect(themeBloc.state.themeMode, equals(ThemeMode.dark));
      expect(themeBloc.state.isDarkMode, equals(true));
      expect(prefs.getString('appThemeModeBloc'), equals('dark'));
    });

    test('UpdateTheme event updates to system theme', () async {
      themeBloc.add(const UpdateTheme(ThemeMode.system));

      // Allow the bloc to process the event
      await Future.delayed(const Duration(milliseconds: 100));

      expect(themeBloc.state.themeMode, equals(ThemeMode.system));
      expect(
        themeBloc.state.isDarkMode,
        equals(false),
      ); // In test environment, system default is light
      expect(prefs.getString('appThemeModeBloc'), isNull);
    });
  });
}
