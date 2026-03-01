import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettingsState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;
  final bool initialized;

  const AppSettingsState({
    required this.themeMode,
    required this.locale,
    required this.initialized,
  });

  const AppSettingsState.initial()
    : themeMode = ThemeMode.light,
      locale = const Locale('uz'),
      initialized = false;

  AppSettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? initialized,
  }) {
    return AppSettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      initialized: initialized ?? this.initialized,
    );
  }

  @override
  List<Object?> get props => [themeMode, locale, initialized];
}
