import '../../../../core/either_dart/either.dart';
import '../../../../core/error/faliures.dart';
import '../entities/weather_entity.dart';
import '../entities/soil_moisture_entity.dart';

/// Weather Repository - Domain qatlam interfeysi
abstract class WeatherRepository {
  /// Ob-havo ma'lumotlarini olish
  /// Internet mavjud bo'lsa API'dan, bo'lmasa keshdan oladi
  Future<Either<Failure, WeatherEntity>> getWeather({
    required double latitude,
    required double longitude,
    int forecastDays = 7,
    bool forceRefresh = false,
  });

  /// Joriy ob-havo ma'lumotlarini olish
  Future<Either<Failure, WeatherEntity>> getCurrentWeather({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  });

  /// Tuproq namligi ma'lumotlarini olish
  Future<Either<Failure, SoilMoistureEntity>> getSoilMoisture({
    required double latitude,
    required double longitude,
    int forecastDays = 7,
    bool forceRefresh = false,
  });

  /// Tarixiy ob-havo ma'lumotlarini olish
  Future<Either<Failure, WeatherEntity>> getHistoricalWeather({
    required double latitude,
    required double longitude,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Keshni tozalash
  Future<void> clearCache();

  /// Kesh mavjud va yangi ekanligini tekshirish
  bool isCacheValid({
    required double latitude,
    required double longitude,
  });
}
