import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart'; // For ThemeMode

class ThemeState extends Equatable {
  // Helper to easily know current dark mode status
  const ThemeState({
    required this.themeMode,
    this.isDarkMode = false, // Default will be updated
  });

  factory ThemeState.initial() {
    // For initial state, we don't know the system brightness yet without context.
    // The LoadTheme event will handle getting the actual initial theme.
    return const ThemeState(themeMode: ThemeMode.system, isDarkMode: false);
  }
  final ThemeMode themeMode;
  final bool isDarkMode;

  ThemeState copyWith({ThemeMode? themeMode, bool? isDarkMode}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  @override
  List<Object> get props => [themeMode, isDarkMode];
}
