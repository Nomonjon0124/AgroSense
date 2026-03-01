import 'package:flutter/material.dart';

abstract class AppSettingsRepository {
  Future<ThemeMode> getThemeMode();

  Future<void> setThemeMode(ThemeMode mode);

  Future<Locale> getLocale();

  Future<void> setLocale(Locale locale);
}

ThemeMode themeModeFromCode(String? code) {
  switch (code) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    case 'system':
    default:
      return ThemeMode.system;
  }
}

String themeModeToCode(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.light:
      return 'light';
    case ThemeMode.dark:
      return 'dark';
    case ThemeMode.system:
      return 'system';
  }
}

Locale localeFromCode(String? code) {
  switch (code) {
    case 'en':
      return const Locale('en');
    case 'ru':
      return const Locale('ru');
    case 'uz':
    default:
      return const Locale('uz');
  }
}

