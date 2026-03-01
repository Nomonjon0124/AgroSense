import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../settings/app_settings_cubit.dart';
import '../settings/app_settings_repository.dart';
import '../settings/hive_app_settings_repository.dart';
import '../../features/presentation/bloc/dashboard/dashboard_bloc.dart';
import '../../features/presentation/bloc/map/map_bloc.dart';
import '../../features/weather/data/datasources/open_meteo_remote_datasource.dart';
import '../../features/weather/data/datasources/soil_grids_remote_datasource.dart';
import '../../features/weather/data/datasources/soil_properties_local_datasource.dart';
import '../../features/weather/data/datasources/weather_local_datasource.dart';
import '../../features/weather/data/repositories/soil_properties_repository_impl.dart';
import '../../features/weather/data/repositories/weather_repository_impl.dart';
import '../../features/weather/domain/repositories/soil_properties_repository.dart';
import '../../features/weather/domain/repositories/weather_repository.dart';
import '../network/network_info.dart';
import '../services/location_service.dart';

/// Global Service Locator
final sl = GetIt.instance;

/// Dependency Injection Container
/// Barcha service, repository va data source'larni shu yerda ro'yxatdan o'tkazamiz
class InjectionContainer {
  /// Barcha dependency'larni ro'yxatdan o'tkazish
  static Future<void> init() async {
    // ==================== CORE ====================

    // Connectivity
    sl.registerLazySingleton<Connectivity>(() => Connectivity());

    // Network Info
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl<Connectivity>()));

    // Location Service
    sl.registerLazySingleton<LocationService>(() => LocationServiceImpl());

    // ==================== HIVE BOXES ====================
    await _initHiveBoxes();

    // ==================== APP SETTINGS ====================

    sl.registerLazySingleton<AppSettingsRepository>(
      () => HiveAppSettingsRepository(
        settingsBox: sl<Box<dynamic>>(instanceName: 'appSettingsBox'),
      ),
    );

    sl.registerLazySingleton<AppSettingsCubit>(
      () => AppSettingsCubit(repository: sl<AppSettingsRepository>()),
    );

    // ==================== DATA SOURCES ====================

    // Remote Data Sources
    sl.registerLazySingleton<OpenMeteoRemoteDataSource>(() => OpenMeteoRemoteDataSourceImpl(networkInfo: sl<NetworkInfo>()));

    sl.registerLazySingleton<SoilGridsRemoteDataSource>(() => SoilGridsRemoteDataSourceImpl(networkInfo: sl<NetworkInfo>()));

    // Local Data Sources
    sl.registerLazySingleton<WeatherLocalDataSource>(
      () => WeatherLocalDataSourceImpl(
        weatherBox: sl<Box<dynamic>>(instanceName: 'weatherBox'),
        soilMoistureBox: sl<Box<dynamic>>(instanceName: 'soilMoistureBox'),
      ),
    );

    sl.registerLazySingleton<SoilPropertiesLocalDataSource>(
      () => SoilPropertiesLocalDataSourceImpl(soilPropertiesBox: sl<Box<dynamic>>(instanceName: 'soilPropertiesBox')),
    );

    // ==================== REPOSITORIES ====================

    sl.registerLazySingleton<WeatherRepository>(
      () => WeatherRepositoryImpl(
        remoteDataSource: sl<OpenMeteoRemoteDataSource>(),
        localDataSource: sl<WeatherLocalDataSource>(),
        networkInfo: sl<NetworkInfo>(),
      ),
    );

    sl.registerLazySingleton<SoilPropertiesRepository>(
      () => SoilPropertiesRepositoryImpl(
        remoteDataSource: sl<SoilGridsRemoteDataSource>(),
        localDataSource: sl<SoilPropertiesLocalDataSource>(),
        networkInfo: sl<NetworkInfo>(),
      ),
    );

    // ==================== BLOCS ====================

    sl.registerFactory<DashboardBloc>(
      () => DashboardBloc(
        weatherRepository: sl<WeatherRepository>(),
        locationService: sl<LocationService>(),
        networkInfo: sl<NetworkInfo>(),
        connectivity: sl<Connectivity>(),
      ),
    );

    sl.registerFactory<MapBloc>(
      () => MapBloc(locationService: sl<LocationService>(), networkInfo: sl<NetworkInfo>(), connectivity: sl<Connectivity>()),
    );
  }

  /// Hive box'larini yaratish va ro'yxatdan o'tkazish
  static Future<void> _initHiveBoxes() async {
    // Hive'ni ishga tushirish
    await Hive.initFlutter();

    // Box'larni ochish
    final weatherBox = await Hive.openBox('weather_cache');
    final soilMoistureBox = await Hive.openBox('soil_moisture_cache');
    final soilPropertiesBox = await Hive.openBox('soil_properties_cache');
    final appSettingsBox = await Hive.openBox('app_settings');

    // Box'larni GetIt'ga ro'yxatdan o'tkazish
    sl.registerSingleton<Box<dynamic>>(weatherBox, instanceName: 'weatherBox');
    sl.registerSingleton<Box<dynamic>>(soilMoistureBox, instanceName: 'soilMoistureBox');
    sl.registerSingleton<Box<dynamic>>(soilPropertiesBox, instanceName: 'soilPropertiesBox');
    sl.registerSingleton<Box<dynamic>>(
      appSettingsBox,
      instanceName: 'appSettingsBox',
    );
  }

  /// Barcha Hive box'larini tozalash (test uchun)
  static Future<void> clearAllCaches() async {
    final weatherBox = sl<Box<dynamic>>(instanceName: 'weatherBox');
    final soilMoistureBox = sl<Box<dynamic>>(instanceName: 'soilMoistureBox');
    final soilPropertiesBox = sl<Box<dynamic>>(instanceName: 'soilPropertiesBox');
    final appSettingsBox = sl<Box<dynamic>>(instanceName: 'appSettingsBox');

    await weatherBox.clear();
    await soilMoistureBox.clear();
    await soilPropertiesBox.clear();
    await appSettingsBox.clear();
  }

  /// GetIt'ni tozalash (test uchun)
  static Future<void> reset() async {
    await sl.reset();
  }
}

/// Storage key'lari
class StorageKeys {
  StorageKeys._();

  // Weather keys
  static String weatherKey(double lat, double lon) => 'weather_${lat}_$lon';

  static String soilMoistureKey(double lat, double lon) => 'soil_moisture_${lat}_$lon';

  static String soilPropertiesKey(double lat, double lon) => 'soil_properties_${lat}_$lon';

  // Timestamp keys
  static String weatherTimestamp(double lat, double lon) => 'weather_ts_${lat}_$lon';

  static String soilMoistureTimestamp(double lat, double lon) => 'soil_moisture_ts_${lat}_$lon';

  static String soilPropertiesTimestamp(double lat, double lon) => 'soil_props_ts_${lat}_$lon';

  // Cache duration (milliseconds)
  static const int weatherCacheDuration = 30 * 60 * 1000; // 30 daqiqa
  static const int soilMoistureCacheDuration = 60 * 60 * 1000; // 1 soat
  static const int soilPropertiesCacheDuration = 24 * 60 * 60 * 1000; // 24 soat
}
