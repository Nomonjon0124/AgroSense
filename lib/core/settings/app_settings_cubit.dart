import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_settings_repository.dart';
import 'app_settings_state.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  final AppSettingsRepository repository;

  AppSettingsCubit({required this.repository})
    : super(const AppSettingsState.initial());

  Future<void> initialize() async {
    final themeMode = await repository.getThemeMode();
    final locale = await repository.getLocale();
    emit(
      state.copyWith(themeMode: themeMode, locale: locale, initialized: true),
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await repository.setThemeMode(mode);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> setLocale(Locale locale) async {
    await repository.setLocale(locale);
    emit(state.copyWith(locale: locale));
  }
}

