import 'dart:io';

import 'package:agro_sense/core/settings/app_settings_repository.dart';
import 'package:agro_sense/core/settings/hive_app_settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

void main() {
  group('HiveAppSettingsRepository', () {
    late Directory tempDir;
    late Box<dynamic> box;
    late HiveAppSettingsRepository repository;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('agro_settings_test');
      Hive.init(tempDir.path);
      box = await Hive.openBox('app_settings');
      repository = HiveAppSettingsRepository(settingsBox: box);
    });

    tearDown(() async {
      await box.close();
      await Hive.deleteBoxFromDisk('app_settings');
      await tempDir.delete(recursive: true);
    });

    test('returns default values when storage is empty', () async {
      final themeMode = await repository.getThemeMode();
      final locale = await repository.getLocale();
      final notificationsEnabled = await repository.getNotificationsEnabled();
      final autoSyncOnWifi = await repository.getAutoSyncOnWifi();
      final lastSync = await repository.getLastManualSyncAt();

      expect(themeMode, ThemeMode.light);
      expect(locale.languageCode, 'uz');
      expect(notificationsEnabled, isTrue);
      expect(autoSyncOnWifi, isTrue);
      expect(lastSync, isNull);
    });

    test('persists and reads theme mode', () async {
      await repository.setThemeMode(ThemeMode.dark);
      final result = await repository.getThemeMode();

      expect(result, ThemeMode.dark);
    });

    test('persists and reads locale', () async {
      await repository.setLocale(const Locale('ru'));
      final result = await repository.getLocale();

      expect(result.languageCode, 'ru');
    });

    test('theme mode mapping functions are stable', () {
      expect(themeModeToCode(ThemeMode.light), 'light');
      expect(themeModeFromCode('dark'), ThemeMode.dark);
      expect(themeModeFromCode('system'), ThemeMode.light);
      expect(localeFromCode('en').languageCode, 'en');
    });

    test('persists extra settings values', () async {
      final now = DateTime.now();
      await repository.setNotificationsEnabled(false);
      await repository.setAutoSyncOnWifi(false);
      await repository.setLastManualSyncAt(now);

      expect(await repository.getNotificationsEnabled(), isFalse);
      expect(await repository.getAutoSyncOnWifi(), isFalse);
      expect(
        (await repository.getLastManualSyncAt())!.millisecondsSinceEpoch,
        now.millisecondsSinceEpoch,
      );
    });
  });
}
