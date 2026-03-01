import 'package:flutter/material.dart';

abstract class AppSettingsRepository {
  Future<ThemeMode> getThemeMode();

  Future<void> setThemeMode(ThemeMode mode);

  Future<Locale> getLocale();

  Future<void> setLocale(Locale locale);

  Future<bool> getNotificationsEnabled();

  Future<void> setNotificationsEnabled(bool value);

  Future<bool> getAutoSyncOnWifi();

  Future<void> setAutoSyncOnWifi(bool value);

  Future<DateTime?> getLastManualSyncAt();

  Future<void> setLastManualSyncAt(DateTime value);
}

ThemeMode themeModeFromCode(String? code) {
  switch (code) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      // "system" and unknown legacy values fallback to light.
      return ThemeMode.light;
  }
}

String themeModeToCode(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.light:
      return 'light';
    case ThemeMode.dark:
      return 'dark';
    case ThemeMode.system:
      return 'light';
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
