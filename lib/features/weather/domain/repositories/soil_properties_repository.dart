import '../../../../core/either_dart/either.dart';
import '../../../../core/error/faliures.dart';
import '../entities/soil_properties_entity.dart';

/// Soil Properties Repository - Domain qatlam interfeysi
abstract class SoilPropertiesRepository {
  /// Tuproq xususiyatlarini olish
  /// Internet mavjud bo'lsa API'dan, bo'lmasa keshdan oladi
  Future<Either<Failure, SoilPropertiesEntity>> getSoilProperties({
    required double latitude,
    required double longitude,
    List<String>? properties,
    List<String>? depths,
    bool forceRefresh = false,
  });

  /// Tuproq teksturasini olish (qum, gil, lyos)
  Future<Either<Failure, SoilPropertiesEntity>> getSoilTexture({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  });

  /// Tuproq unumdorligini olish (pH, azot, organik uglerod)
  Future<Either<Failure, SoilPropertiesEntity>> getSoilFertility({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  });

  /// Tuproq suv saqlash xususiyatlarini olish
  Future<Either<Failure, SoilPropertiesEntity>> getSoilWaterProperties({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  });

  /// Barcha tuproq xususiyatlarini olish
  Future<Either<Failure, SoilPropertiesEntity>> getAllSoilProperties({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  });

  /// Keshni tozalash
  Future<void> clearCache();

  /// Kesh mavjud va yangi ekanligini tekshirish
  bool isCacheValid({
    required double latitude,
    required double longitude,
  });
}
