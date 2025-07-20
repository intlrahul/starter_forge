import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_event.dart';
import 'theme_state.dart';

const String _themePrefsKey =
    'appThemeModeBloc'; // Use a different key if you ran the counter version

@injectable
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<LoadTheme>(_onLoadTheme);
    on<UpdateTheme>(_onUpdateTheme);

    // Load the initial theme when the BLoC is created
    add(LoadTheme());
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_themePrefsKey);
    ThemeMode currentMode = ThemeMode.system;

    if (themeModeString == 'light') {
      currentMode = ThemeMode.light;
    } else if (themeModeString == 'dark') {
      currentMode = ThemeMode.dark;
    }

    // Determine isDarkMode based on currentMode
    bool isCurrentlyDark;
    if (currentMode == ThemeMode.system) {
      // This relies on the system brightness at the time of loading.
      // It's generally good, but changes to system theme while app is running
      // without restarting might not be reflected in `isDarkMode` until next LoadTheme/UpdateTheme.
      // The UI typically handles this with `MediaQuery.of(context).platformBrightness`.
      isCurrentlyDark =
          WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    } else {
      isCurrentlyDark = currentMode == ThemeMode.dark;
    }

    emit(state.copyWith(themeMode: currentMode, isDarkMode: isCurrentlyDark));
  }

  Future<void> _onUpdateTheme(
    UpdateTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final newMode = event.themeMode;

    if (newMode == ThemeMode.light) {
      await prefs.setString(_themePrefsKey, 'light');
    } else if (newMode == ThemeMode.dark) {
      await prefs.setString(_themePrefsKey, 'dark');
    } else {
      // System
      await prefs.remove(_themePrefsKey);
    }

    bool isCurrentlyDark;
    if (newMode == ThemeMode.system) {
      isCurrentlyDark =
          WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    } else {
      isCurrentlyDark = newMode == ThemeMode.dark;
    }

    emit(state.copyWith(themeMode: newMode, isDarkMode: isCurrentlyDark));
  }
}
