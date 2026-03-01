import 'package:hive_ce/hive.dart';
import 'package:flutter/material.dart';

import 'app_settings_repository.dart';

class HiveAppSettingsRepository implements AppSettingsRepository {
  static const String themeKey = 'app_theme_mode';
  static const String localeKey = 'app_locale_code';
  static const String notificationsEnabledKey = 'notifications_enabled';
  static const String autoSyncOnWifiKey = 'auto_sync_wifi';
  static const String lastManualSyncKey = 'last_manual_sync_ms';

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

  @override
  Future<bool> getNotificationsEnabled() async {
    return settingsBox.get(notificationsEnabledKey) as bool? ?? true;
  }

  @override
  Future<void> setNotificationsEnabled(bool value) async {
    await settingsBox.put(notificationsEnabledKey, value);
  }

  @override
  Future<bool> getAutoSyncOnWifi() async {
    return settingsBox.get(autoSyncOnWifiKey) as bool? ?? true;
  }

  @override
  Future<void> setAutoSyncOnWifi(bool value) async {
    await settingsBox.put(autoSyncOnWifiKey, value);
  }

  @override
  Future<DateTime?> getLastManualSyncAt() async {
    final millis = settingsBox.get(lastManualSyncKey) as int?;
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  @override
  Future<void> setLastManualSyncAt(DateTime value) async {
    await settingsBox.put(lastManualSyncKey, value.millisecondsSinceEpoch);
  }
}
