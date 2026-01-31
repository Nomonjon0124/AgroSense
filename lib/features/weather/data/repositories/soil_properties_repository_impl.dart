import '../../../../core/either_dart/either.dart';
import '../../../../core/error/faliures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/soil_properties_entity.dart';
import '../../domain/repositories/soil_properties_repository.dart';
import '../datasources/soil_grids_remote_datasource.dart';
import '../datasources/soil_properties_local_datasource.dart';

/// Soil Properties Repository implementatsiyasi
/// Offline-first pattern: avval keshdan, keyin serverdan
class SoilPropertiesRepositoryImpl implements SoilPropertiesRepository {
  final SoilGridsRemoteDataSource remoteDataSource;
  final SoilPropertiesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SoilPropertiesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, SoilPropertiesEntity>> getSoilProperties({
    required double latitude,
    required double longitude,
    List<String>? properties,
    List<String>? depths,
    bool forceRefresh = false,
  }) async {
    // Kesh tekshirish
    if (!forceRefresh && localDataSource.isCacheValid(
      latitude: latitude,
      longitude: longitude,
    )) {
      final cachedData = await localDataSource.getCachedSoilProperties(
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
        final response = await remoteDataSource.getSoilProperties(
          latitude: latitude,
          longitude: longitude,
          properties: properties,
          depths: depths,
        );
        
        // Keshga saqlash
        await localDataSource.cacheSoilProperties(
          latitude: latitude,
          longitude: longitude,
          properties: response,
        );
        
        return Right(response.toEntity());
      } catch (e) {
        return _getFromCache(latitude, longitude);
      }
    } else {
      return _getFromCache(latitude, longitude);
    }
  }

  /// Keshdan tuproq xususiyatlarini olish
  Future<Either<Failure, SoilPropertiesEntity>> _getFromCache(
    double latitude,
    double longitude,
  ) async {
    final cachedData = await localDataSource.getCachedSoilProperties(
      latitude: latitude,
      longitude: longitude,
    );
    
    if (cachedData != null) {
      return Right(cachedData.toEntity());
    }
    
    return Left(CacheFailure.notFound(
      'Tuproq xususiyatlari ma\'lumotlari topilmadi. Internet ulanishini tekshiring.',
    ));
  }

  @override
  Future<Either<Failure, SoilPropertiesEntity>> getSoilTexture({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && localDataSource.isCacheValid(
      latitude: latitude,
      longitude: longitude,
    )) {
      final cachedData = await localDataSource.getCachedSoilProperties(
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
        final response = await remoteDataSource.getSoilTexture(
          latitude: latitude,
          longitude: longitude,
        );
        
        await localDataSource.cacheSoilProperties(
          latitude: latitude,
          longitude: longitude,
          properties: response,
        );
        
        return Right(response.toEntity());
      } catch (e) {
        return _getFromCache(latitude, longitude);
      }
    } else {
      return _getFromCache(latitude, longitude);
    }
  }

  @override
  Future<Either<Failure, SoilPropertiesEntity>> getSoilFertility({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && localDataSource.isCacheValid(
      latitude: latitude,
      longitude: longitude,
    )) {
      final cachedData = await localDataSource.getCachedSoilProperties(
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
        final response = await remoteDataSource.getSoilFertility(
          latitude: latitude,
          longitude: longitude,
        );
        
        await localDataSource.cacheSoilProperties(
          latitude: latitude,
          longitude: longitude,
          properties: response,
        );
        
        return Right(response.toEntity());
      } catch (e) {
        return _getFromCache(latitude, longitude);
      }
    } else {
      return _getFromCache(latitude, longitude);
    }
  }

  @override
  Future<Either<Failure, SoilPropertiesEntity>> getSoilWaterProperties({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && localDataSource.isCacheValid(
      latitude: latitude,
      longitude: longitude,
    )) {
      final cachedData = await localDataSource.getCachedSoilProperties(
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
        final response = await remoteDataSource.getSoilWaterProperties(
          latitude: latitude,
          longitude: longitude,
        );
        
        await localDataSource.cacheSoilProperties(
          latitude: latitude,
          longitude: longitude,
          properties: response,
        );
        
        return Right(response.toEntity());
      } catch (e) {
        return _getFromCache(latitude, longitude);
      }
    } else {
      return _getFromCache(latitude, longitude);
    }
  }

  @override
  Future<Either<Failure, SoilPropertiesEntity>> getAllSoilProperties({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && localDataSource.isCacheValid(
      latitude: latitude,
      longitude: longitude,
    )) {
      final cachedData = await localDataSource.getCachedSoilProperties(
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
        final response = await remoteDataSource.getAllSoilProperties(
          latitude: latitude,
          longitude: longitude,
        );
        
        await localDataSource.cacheSoilProperties(
          latitude: latitude,
          longitude: longitude,
          properties: response,
        );
        
        return Right(response.toEntity());
      } catch (e) {
        return _getFromCache(latitude, longitude);
      }
    } else {
      return _getFromCache(latitude, longitude);
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
    return localDataSource.isCacheValid(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
