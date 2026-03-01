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

      expect(themeMode, ThemeMode.system);
      expect(locale.languageCode, 'uz');
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
      expect(localeFromCode('en').languageCode, 'en');
    });
  });
}
