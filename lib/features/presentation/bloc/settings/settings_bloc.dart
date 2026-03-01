import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/network/network_info.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/settings/app_settings_cubit.dart';
import '../../../../core/settings/app_settings_repository.dart';
import '../../../../core/settings/storage_stats_service.dart';
import '../../../weather/domain/repositories/soil_properties_repository.dart';
import '../../../weather/domain/repositories/weather_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AppSettingsCubit appSettingsCubit;
  final AppSettingsRepository appSettingsRepository;
  final WeatherRepository weatherRepository;
  final SoilPropertiesRepository soilPropertiesRepository;
  final LocationService locationService;
  final NetworkInfo networkInfo;
  final StorageStatsService storageStatsService;
  final Future<PackageInfo> Function() packageInfoLoader;

  StreamSubscription<bool>? _connectivitySubscription;

  SettingsBloc({
    required this.appSettingsCubit,
    required this.appSettingsRepository,
    required this.weatherRepository,
    required this.soilPropertiesRepository,
    required this.locationService,
    required this.networkInfo,
    required this.storageStatsService,
    Future<PackageInfo> Function()? packageInfoLoader,
  }) : packageInfoLoader = packageInfoLoader ?? PackageInfo.fromPlatform,
       super(SettingsState.initial()) {
    on<SettingsStarted>(_onStarted);
    on<NotificationsToggled>(_onNotificationsToggled);
    on<AutoSyncToggled>(_onAutoSyncToggled);
    on<DarkModeToggled>(_onDarkModeToggled);
    on<LanguageChanged>(_onLanguageChanged);
    on<CleanUpPressed>(_onCleanUpPressed);
    on<SyncNowPressed>(_onSyncNowPressed);
    on<ErrorShown>(_onErrorShown);
    on<ConnectivityChanged>(_onConnectivityChanged);

    _connectivitySubscription = networkInfo.onConnectivityChanged.listen((
      isOnline,
    ) {
      add(ConnectivityChanged(isOnline));
    });
  }

  Future<void> _onStarted(
    SettingsStarted event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));

    try {
      final settingsState = appSettingsCubit.state;
      final notificationsEnabled =
          await appSettingsRepository.getNotificationsEnabled();
      final autoSyncOnWifi = await appSettingsRepository.getAutoSyncOnWifi();
      final lastSyncedAt = await appSettingsRepository.getLastManualSyncAt();
      final isOnline = await networkInfo.isConnected;
      final stats = await storageStatsService.computeStats();
      final info = await _safeLoadPackageInfo();

      emit(
        state.copyWith(
          isLoading: false,
          isOnline: isOnline,
          notificationsEnabled: notificationsEnabled,
          autoSyncOnWifi: autoSyncOnWifi,
          lastSyncedAt: lastSyncedAt,
          themeMode: settingsState.themeMode,
          locale: settingsState.locale,
          storageUsedBytes: stats.usedBytes,
          storageBudgetBytes: stats.budgetBytes,
          storageEntryCount: stats.entryCount,
          appVersion: info.version,
          appBuildNumber: info.buildNumber,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load settings.',
        ),
      );
    }
  }

  Future<void> _onNotificationsToggled(
    NotificationsToggled event,
    Emitter<SettingsState> emit,
  ) async {
    await appSettingsRepository.setNotificationsEnabled(event.enabled);
    emit(state.copyWith(notificationsEnabled: event.enabled));
  }

  Future<void> _onAutoSyncToggled(
    AutoSyncToggled event,
    Emitter<SettingsState> emit,
  ) async {
    await appSettingsRepository.setAutoSyncOnWifi(event.enabled);
    emit(state.copyWith(autoSyncOnWifi: event.enabled));
  }

  Future<void> _onDarkModeToggled(
    DarkModeToggled event,
    Emitter<SettingsState> emit,
  ) async {
    final mode = event.isDark ? ThemeMode.dark : ThemeMode.light;
    await appSettingsCubit.setThemeMode(mode);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> _onLanguageChanged(
    LanguageChanged event,
    Emitter<SettingsState> emit,
  ) async {
    await appSettingsCubit.setLocale(event.locale);
    emit(state.copyWith(locale: event.locale));
  }

  Future<void> _onCleanUpPressed(
    CleanUpPressed event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));

    try {
      await storageStatsService.clearOfflineCaches();
      final stats = await storageStatsService.computeStats();
      emit(
        state.copyWith(
          isLoading: false,
          storageUsedBytes: stats.usedBytes,
          storageBudgetBytes: stats.budgetBytes,
          storageEntryCount: stats.entryCount,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to clear storage.',
        ),
      );
    }
  }

  Future<void> _onSyncNowPressed(
    SyncNowPressed event,
    Emitter<SettingsState> emit,
  ) async {
    if (state.isSyncing) return;

    emit(state.copyWith(isSyncing: true, clearErrorMessage: true));

    final isOnline = await networkInfo.isConnected;
    if (!isOnline) {
      emit(
        state.copyWith(
          isSyncing: false,
          isOnline: false,
          errorMessage: 'No internet connection. Sync failed.',
        ),
      );
      return;
    }

    try {
      final location = await locationService.getCurrentLocation();

      final results = await Future.wait([
        weatherRepository.getWeather(
          latitude: location.latitude,
          longitude: location.longitude,
          forceRefresh: true,
        ),
        weatherRepository.getSoilMoisture(
          latitude: location.latitude,
          longitude: location.longitude,
          forceRefresh: true,
        ),
        soilPropertiesRepository.getAllSoilProperties(
          latitude: location.latitude,
          longitude: location.longitude,
          forceRefresh: true,
        ),
      ]);

      final allSucceeded = results.every((result) => result.isRight);
      if (!allSucceeded) {
        emit(
          state.copyWith(
            isSyncing: false,
            errorMessage: 'Some data failed to sync.',
          ),
        );
        return;
      }

      final now = DateTime.now();
      await appSettingsRepository.setLastManualSyncAt(now);
      final stats = await storageStatsService.computeStats();

      emit(
        state.copyWith(
          isSyncing: false,
          isOnline: true,
          lastSyncedAt: now,
          lastMapSyncAt: now,
          storageUsedBytes: stats.usedBytes,
          storageBudgetBytes: stats.budgetBytes,
          storageEntryCount: stats.entryCount,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSyncing: false,
          errorMessage: 'Sync failed. Please try again.',
        ),
      );
    }
  }

  void _onErrorShown(ErrorShown event, Emitter<SettingsState> emit) {
    emit(state.copyWith(clearErrorMessage: true));
  }

  void _onConnectivityChanged(
    ConnectivityChanged event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(isOnline: event.isOnline));
  }

  Future<PackageInfo> _safeLoadPackageInfo() async {
    try {
      return await packageInfoLoader();
    } catch (_) {
      return PackageInfo(
        appName: 'AgroSense',
        packageName: 'agro_sense',
        version: '--',
        buildNumber: '--',
      );
    }
  }

  @override
  Future<void> close() async {
    await _connectivitySubscription?.cancel();
    return super.close();
  }
}
