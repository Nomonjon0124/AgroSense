import 'dart:async';
import 'dart:io';

import 'package:agro_sense/core/either_dart/either.dart';
import 'package:agro_sense/core/error/faliures.dart';
import 'package:agro_sense/core/network/network_info.dart';
import 'package:agro_sense/core/services/location_service.dart';
import 'package:agro_sense/core/settings/app_settings_cubit.dart';
import 'package:agro_sense/core/settings/app_settings_repository.dart';
import 'package:agro_sense/core/settings/storage_stats_service.dart';
import 'package:agro_sense/features/presentation/bloc/settings/settings_bloc.dart';
import 'package:agro_sense/features/presentation/pages/settings/settings_part.dart';
import 'package:agro_sense/features/weather/domain/entities/soil_moisture_entity.dart';
import 'package:agro_sense/features/weather/domain/entities/soil_properties_entity.dart';
import 'package:agro_sense/features/weather/domain/entities/weather_entity.dart';
import 'package:agro_sense/features/weather/domain/repositories/soil_properties_repository.dart';
import 'package:agro_sense/features/weather/domain/repositories/weather_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';

class _Repo implements AppSettingsRepository {
  ThemeMode mode = ThemeMode.light;
  Locale locale = const Locale('en');
  bool notificationsEnabled = true;
  bool autoSync = true;
  DateTime? lastSync;

  @override
  Future<bool> getAutoSyncOnWifi() async => autoSync;

  @override
  Future<Locale> getLocale() async => locale;

  @override
  Future<DateTime?> getLastManualSyncAt() async => lastSync;

  @override
  Future<bool> getNotificationsEnabled() async => notificationsEnabled;

  @override
  Future<ThemeMode> getThemeMode() async => mode;

  @override
  Future<void> setAutoSyncOnWifi(bool value) async => autoSync = value;

  @override
  Future<void> setLastManualSyncAt(DateTime value) async => lastSync = value;

  @override
  Future<void> setLocale(Locale locale) async => this.locale = locale;

  @override
  Future<void> setNotificationsEnabled(bool value) async =>
      notificationsEnabled = value;

  @override
  Future<void> setThemeMode(ThemeMode mode) async => this.mode = mode;
}

class _WeatherRepo implements WeatherRepository {
  int weatherCalls = 0;
  int soilCalls = 0;

  @override
  Future<void> clearCache() async {}

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeather({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, WeatherEntity>> getHistoricalWeather({
    required double latitude,
    required double longitude,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, SoilMoistureEntity>> getSoilMoisture({
    required double latitude,
    required double longitude,
    int forecastDays = 7,
    bool forceRefresh = false,
  }) async {
    soilCalls++;
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return Right(
      SoilMoistureEntity(
        latitude: latitude,
        longitude: longitude,
        elevation: 0,
        timezone: 'UTC',
      ),
    );
  }

  @override
  Future<Either<Failure, WeatherEntity>> getWeather({
    required double latitude,
    required double longitude,
    int forecastDays = 7,
    bool forceRefresh = false,
  }) async {
    weatherCalls++;
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return Right(
      WeatherEntity(
        latitude: latitude,
        longitude: longitude,
        elevation: 0,
        timezone: 'UTC',
      ),
    );
  }

  @override
  bool isCacheValid({required double latitude, required double longitude}) =>
      false;
}

class _SoilRepo implements SoilPropertiesRepository {
  int calls = 0;

  @override
  Future<void> clearCache() async {}

  @override
  Future<Either<Failure, SoilPropertiesEntity>> getAllSoilProperties({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) async {
    calls++;
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return Right(
      SoilPropertiesEntity(
        latitude: latitude,
        longitude: longitude,
        layers: const [],
      ),
    );
  }

  @override
  Future<Either<Failure, SoilPropertiesEntity>> getSoilFertility({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, SoilPropertiesEntity>> getSoilProperties({
    required double latitude,
    required double longitude,
    List<String>? properties,
    List<String>? depths,
    bool forceRefresh = false,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, SoilPropertiesEntity>> getSoilTexture({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, SoilPropertiesEntity>> getSoilWaterProperties({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) {
    throw UnimplementedError();
  }

  @override
  bool isCacheValid({required double latitude, required double longitude}) =>
      false;
}

class _Network implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;

  @override
  Stream<bool> get onConnectivityChanged => const Stream<bool>.empty();

  @override
  Future<NetworkType> get networkType async => NetworkType.wifi;
}

class _Location implements LocationService {
  @override
  Future<bool> checkPermission() async => true;

  @override
  Future<LocationData> getCurrentLocation() async {
    return LocationData(
      latitude: 41.3,
      longitude: 69.2,
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<String?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async => null;

  @override
  Future<bool> isLocationServiceEnabled() async => true;

  @override
  Future<bool> requestPermission() async => true;
}

void main() {
  testWidgets('Settings renders storage and executes sync/cleanup actions', (
    tester,
  ) async {
    final repo = _Repo();
    final appCubit = AppSettingsCubit(repository: repo);
    await appCubit.initialize();

    final weatherRepo = _WeatherRepo();
    final soilRepo = _SoilRepo();

    final tempDir = await Directory.systemTemp.createTemp('settings_sync_test');
    Hive.init(tempDir.path);
    final weather = await Hive.openBox('weather_cache');
    final soilM = await Hive.openBox('soil_moisture_cache');
    final soilP = await Hive.openBox('soil_properties_cache');

    await weather.put('k1', 'value1');
    await soilM.put('k2', 'value2');
    await soilP.put('k3', 'value3');

    final bloc = SettingsBloc(
      appSettingsCubit: appCubit,
      appSettingsRepository: repo,
      weatherRepository: weatherRepo,
      soilPropertiesRepository: soilRepo,
      locationService: _Location(),
      networkInfo: _Network(),
      storageStatsService: StorageStatsService(
        weatherBox: weather,
        soilMoistureBox: soilM,
        soilPropertiesBox: soilP,
      ),
      packageInfoLoader:
          () async => PackageInfo(
            appName: 'AgroSense',
            packageName: 'agro_sense',
            version: '1.2.3',
            buildNumber: '7',
          ),
    )..add(const SettingsStarted());

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: appCubit),
            BlocProvider.value(value: bloc),
          ],
          child: const SettingsView(),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Offline Data Manager'), findsOneWidget);
    expect(find.text('Version 1.2.3 (Build 7)'), findsOneWidget);
    expect(find.text('3 entries'), findsOneWidget);

    await tester.tap(find.text('Sync Now'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 300));

    expect(weatherRepo.weatherCalls, greaterThan(0));
    expect(weatherRepo.soilCalls, greaterThan(0));
    expect(soilRepo.calls, greaterThan(0));
    expect(repo.lastSync, isNotNull);

    await tester.tap(find.text('Clean Up'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('0 entries'), findsOneWidget);

    await bloc.close();
    await weather.close();
    await soilM.close();
    await soilP.close();
    await tempDir.delete(recursive: true);
  });
}
