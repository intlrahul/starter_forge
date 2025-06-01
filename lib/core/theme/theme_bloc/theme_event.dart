import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart'; // For ThemeMode

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

// Event to load the initial theme from storage
class LoadTheme extends ThemeEvent {}

// Event to change the theme
class UpdateTheme extends ThemeEvent {
  const UpdateTheme(this.themeMode);

  final ThemeMode themeMode;

  @override
  List<Object?> get props => [themeMode];
}
