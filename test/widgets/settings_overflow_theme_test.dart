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

  @override
  Future<bool> getAutoSyncOnWifi() async => true;

  @override
  Future<Locale> getLocale() async => locale;

  @override
  Future<DateTime?> getLastManualSyncAt() async => null;

  @override
  Future<bool> getNotificationsEnabled() async => true;

  @override
  Future<ThemeMode> getThemeMode() async => mode;

  @override
  Future<void> setAutoSyncOnWifi(bool value) async {}

  @override
  Future<void> setLastManualSyncAt(DateTime value) async {}

  @override
  Future<void> setLocale(Locale locale) async => this.locale = locale;

  @override
  Future<void> setNotificationsEnabled(bool value) async {}

  @override
  Future<void> setThemeMode(ThemeMode mode) async => this.mode = mode;
}

class _WeatherRepo implements WeatherRepository {
  @override
  Future<void> clearCache() async {}

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeather({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, WeatherEntity>> getHistoricalWeather({
    required double latitude,
    required double longitude,
    required DateTime startDate,
    required DateTime endDate,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, SoilMoistureEntity>> getSoilMoisture({
    required double latitude,
    required double longitude,
    int forecastDays = 7,
    bool forceRefresh = false,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, WeatherEntity>> getWeather({
    required double latitude,
    required double longitude,
    int forecastDays = 7,
    bool forceRefresh = false,
  }) => throw UnimplementedError();

  @override
  bool isCacheValid({required double latitude, required double longitude}) =>
      false;
}

class _SoilRepo implements SoilPropertiesRepository {
  @override
  Future<void> clearCache() async {}

  @override
  Future<Either<Failure, SoilPropertiesEntity>> getAllSoilProperties({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, SoilPropertiesEntity>> getSoilFertility({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, SoilPropertiesEntity>> getSoilProperties({
    required double latitude,
    required double longitude,
    List<String>? properties,
    List<String>? depths,
    bool forceRefresh = false,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, SoilPropertiesEntity>> getSoilTexture({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, SoilPropertiesEntity>> getSoilWaterProperties({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) => throw UnimplementedError();

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
  Future<LocationData> getCurrentLocation() async =>
      LocationData(latitude: 41.0, longitude: 69.0, timestamp: DateTime.now());

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
  testWidgets('Settings has no overflow in en/ru/uz and light/dark', (
    tester,
  ) async {
    final errors = <FlutterErrorDetails>[];
    final oldHandler = FlutterError.onError;
    FlutterError.onError = (details) => errors.add(details);

    for (final locale in const [Locale('en'), Locale('ru'), Locale('uz')]) {
      for (final mode in const [ThemeMode.light, ThemeMode.dark]) {
        final repo =
            _Repo()
              ..mode = mode
              ..locale = locale;
        final cubit = AppSettingsCubit(repository: repo);
        await cubit.initialize();

        final tempDir = await Directory.systemTemp.createTemp(
          'settings_overflow',
        );
        Hive.init(tempDir.path);
        final weather = await Hive.openBox('w');
        final soilM = await Hive.openBox('sm');
        final soilP = await Hive.openBox('sp');

        final bloc = SettingsBloc(
          appSettingsCubit: cubit,
          appSettingsRepository: repo,
          weatherRepository: _WeatherRepo(),
          soilPropertiesRepository: _SoilRepo(),
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
                version: '1.0.0',
                buildNumber: '1',
              ),
        )..add(const SettingsStarted());

        await tester.binding.setSurfaceSize(const Size(320, 690));
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            themeMode: mode,
            theme: ThemeData(useMaterial3: true),
            darkTheme: ThemeData.dark(useMaterial3: true),
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: cubit),
                BlocProvider.value(value: bloc),
              ],
              child: const SettingsView(),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        await bloc.close();
        await weather.close();
        await soilM.close();
        await soilP.close();
        await tempDir.delete(recursive: true);
      }
    }

    await tester.binding.setSurfaceSize(null);
    FlutterError.onError = oldHandler;

    final overflow = errors.where(
      (e) => e.exceptionAsString().contains('A RenderFlex overflowed'),
    );
    expect(overflow, isEmpty);
  });
}
