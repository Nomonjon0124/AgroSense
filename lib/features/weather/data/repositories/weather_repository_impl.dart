import '../../../../core/either_dart/either.dart';
import '../../../../core/error/faliures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/entities/soil_moisture_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/open_meteo_remote_datasource.dart';
import '../datasources/weather_local_datasource.dart';

/// Weather Repository implementatsiyasi
/// Offline-first pattern: avval keshdan, keyin serverdan
class WeatherRepositoryImpl implements WeatherRepository {
  final OpenMeteoRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, WeatherEntity>> getWeather({
    required double latitude,
    required double longitude,
    int forecastDays = 7,
    bool forceRefresh = false,
  }) async {
    // Agar kesh yangi bo'lsa va majburiy yangilash so'ralmagan bo'lsa
    if (!forceRefresh && localDataSource.isWeatherCacheValid(
      latitude: latitude,
      longitude: longitude,
    )) {
      final cachedData = await localDataSource.getCachedWeather(
        latitude: latitude,
        longitude: longitude,
      );
      if (cachedData != null) {
        return Right(cachedData.toEntity());
      }
    }

    // Internet tekshirish
    final isConnected = await networkInfo.isConnected;
    
    if (isConnected) {
      try {
        final response = await remoteDataSource.getFullWeatherData(
          latitude: latitude,
          longitude: longitude,
          forecastDays: forecastDays,
        );
        
        // Keshga saqlash
        await localDataSource.cacheWeather(
          latitude: latitude,
          longitude: longitude,
          weather: response,
        );
        
        return Right(response.toEntity());
      } catch (e) {
        // API xatosi bo'lsa, keshdan olishga harakat qilish
        return _getWeatherFromCache(latitude, longitude);
      }
    } else {
      // Internet yo'q, keshdan olish
      return _getWeatherFromCache(latitude, longitude);
    }
  }

  /// Keshdan ob-havo olish
  Future<Either<Failure, WeatherEntity>> _getWeatherFromCache(
    double latitude,
    double longitude,
  ) async {
    final cachedData = await localDataSource.getCachedWeather(
      latitude: latitude,
      longitude: longitude,
    );
    
    if (cachedData != null) {
      return Right(cachedData.toEntity());
    }
    
    return Left(CacheFailure.notFound(
      'Ob-havo ma\'lumotlari topilmadi. Internet ulanishini tekshiring.',
    ));
  }

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeather({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) async {
    // Agar kesh yangi bo'lsa
    if (!forceRefresh && localDataSource.isWeatherCacheValid(
      latitude: latitude,
      longitude: longitude,
    )) {
      final cachedData = await localDataSource.getCachedWeather(
        latitude: latitude,
        longitude: longitude,
      );
      if (cachedData != null) {
        return Right(cachedData.toEntity());
      }
    }

    final isConnected = await networkInfo.isConnected;
    
    if (isConnected) {
      try {
        final response = await remoteDataSource.getCurrentWeather(
          latitude: latitude,
          longitude: longitude,
        );
        
        await localDataSource.cacheWeather(
          latitude: latitude,
          longitude: longitude,
          weather: response,
        );
        
        return Right(response.toEntity());
      } catch (e) {
        return _getWeatherFromCache(latitude, longitude);
      }
    } else {
      return _getWeatherFromCache(latitude, longitude);
    }
  }

  @override
  Future<Either<Failure, SoilMoistureEntity>> getSoilMoisture({
    required double latitude,
    required double longitude,
    int forecastDays = 7,
    bool forceRefresh = false,
  }) async {
    // Kesh tekshirish
    if (!forceRefresh && localDataSource.isSoilMoistureCacheValid(
      latitude: latitude,
      longitude: longitude,
    )) {
      final cachedData = await localDataSource.getCachedSoilMoisture(
        latitude: latitude,
        longitude: longitude,
      );
      if (cachedData != null) {
        return Right(cachedData.toEntity());
      }
    }

    final isConnected = await networkInfo.isConnected;
    
    if (isConnected) {
      try {
        final response = await remoteDataSource.getSoilMoisture(
          latitude: latitude,
          longitude: longitude,
          forecastDays: forecastDays,
        );
        
        await localDataSource.cacheSoilMoisture(
          latitude: latitude,
          longitude: longitude,
          soilMoisture: response,
        );
        
        return Right(response.toEntity());
      } catch (e) {
        return _getSoilMoistureFromCache(latitude, longitude);
      }
    } else {
      return _getSoilMoistureFromCache(latitude, longitude);
    }
  }

  /// Keshdan tuproq namligi olish
  Future<Either<Failure, SoilMoistureEntity>> _getSoilMoistureFromCache(
    double latitude,
    double longitude,
  ) async {
    final cachedData = await localDataSource.getCachedSoilMoisture(
      latitude: latitude,
      longitude: longitude,
    );
    
    if (cachedData != null) {
      return Right(cachedData.toEntity());
    }
    
    return Left(CacheFailure.notFound(
      'Tuproq namligi ma\'lumotlari topilmadi. Internet ulanishini tekshiring.',
    ));
  }

  @override
  Future<Either<Failure, WeatherEntity>> getHistoricalWeather({
    required double latitude,
    required double longitude,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // Tarixiy ma'lumotlar faqat internetdan olinadi
    final isConnected = await networkInfo.isConnected;
    
    if (!isConnected) {
      return Left(NetworkFailure.noConnection());
    }
    
    try {
      final response = await remoteDataSource.getHistoricalWeather(
        latitude: latitude,
        longitude: longitude,
        startDate: startDate,
        endDate: endDate,
      );
      
      return Right(response.toEntity());
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(const UnknownFailure());
    }
  }

  @override
  Future<void> clearCache() async {
    await localDataSource.clearAll();
  }

  @override
  bool isCacheValid({
    required double latitude,
    required double longitude,
  }) {
    return localDataSource.isWeatherCacheValid(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
