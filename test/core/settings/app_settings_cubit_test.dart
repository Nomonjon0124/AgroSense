import 'package:agro_sense/core/settings/app_settings_cubit.dart';
import 'package:agro_sense/core/settings/app_settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAppSettingsRepository implements AppSettingsRepository {
  ThemeMode storedTheme = ThemeMode.light;
  Locale storedLocale = const Locale('uz');
  bool notificationsEnabled = true;
  bool autoSyncOnWifi = true;
  DateTime? lastManualSyncAt;

  @override
  Future<Locale> getLocale() async => storedLocale;

  @override
  Future<ThemeMode> getThemeMode() async => storedTheme;

  @override
  Future<void> setLocale(Locale locale) async {
    storedLocale = locale;
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    storedTheme = mode;
  }

  @override
  Future<bool> getNotificationsEnabled() async => notificationsEnabled;

  @override
  Future<void> setNotificationsEnabled(bool value) async {
    notificationsEnabled = value;
  }

  @override
  Future<bool> getAutoSyncOnWifi() async => autoSyncOnWifi;

  @override
  Future<void> setAutoSyncOnWifi(bool value) async {
    autoSyncOnWifi = value;
  }

  @override
  Future<DateTime?> getLastManualSyncAt() async => lastManualSyncAt;

  @override
  Future<void> setLastManualSyncAt(DateTime value) async {
    lastManualSyncAt = value;
  }
}

void main() {
  group('AppSettingsCubit', () {
    late _FakeAppSettingsRepository repository;
    late AppSettingsCubit cubit;

    setUp(() {
      repository = _FakeAppSettingsRepository();
      cubit = AppSettingsCubit(repository: repository);
    });

    test('initialize loads repository values', () async {
      repository.storedTheme = ThemeMode.dark;
      repository.storedLocale = const Locale('en');

      await cubit.initialize();

      expect(cubit.state.initialized, true);
      expect(cubit.state.themeMode, ThemeMode.dark);
      expect(cubit.state.locale.languageCode, 'en');
    });

    test('setThemeMode updates state and persistence', () async {
      await cubit.setThemeMode(ThemeMode.light);

      expect(cubit.state.themeMode, ThemeMode.light);
      expect(repository.storedTheme, ThemeMode.light);
    });

    test('setLocale updates state and persistence', () async {
      await cubit.setLocale(const Locale('ru'));

      expect(cubit.state.locale.languageCode, 'ru');
      expect(repository.storedLocale.languageCode, 'ru');
    });
  });
}
