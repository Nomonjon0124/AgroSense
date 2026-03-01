import 'package:hive_ce/hive.dart';
import 'package:flutter/material.dart';

import 'app_settings_repository.dart';

class HiveAppSettingsRepository implements AppSettingsRepository {
  static const String themeKey = 'app_theme_mode';
  static const String localeKey = 'app_locale_code';

  final Box<dynamic> settingsBox;

  HiveAppSettingsRepository({required this.settingsBox});

  @override
  Future<ThemeMode> getThemeMode() async {
    final code = settingsBox.get(themeKey) as String?;
    return themeModeFromCode(code);
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    await settingsBox.put(themeKey, themeModeToCode(mode));
  }

  @override
  Future<Locale> getLocale() async {
    final code = settingsBox.get(localeKey) as String?;
    return localeFromCode(code);
  }

  @override
  Future<void> setLocale(Locale locale) async {
    await settingsBox.put(localeKey, locale.languageCode);
  }
}

