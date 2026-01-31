import 'package:dio/dio.dart';


import '../../../../core/constants/soil_grids_constants.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/error/faliures.dart';
import '../models/soil_properties_response_model.dart';

/// SoilGrids API bilan ishlash uchun Remote Data Source
/// Tuproq xususiyatlari ma'lumotlarini olish (ISRIC)
abstract class SoilGridsRemoteDataSource {
  /// Tuproq xususiyatlarini olish
  Future<SoilPropertiesResponseModel> getSoilProperties({
    required double latitude,
    required double longitude,
    List<String>? properties,
    List<String>? depths,
    String valueType = 'mean',
  });

  /// Asosiy tuproq tarkibini olish (qum, gil, lyos)
  Future<SoilPropertiesResponseModel> getSoilTexture({
    required double latitude,
    required double longitude,
    List<String>? depths,
  });

  /// Tuproq unumdorligini olish (organik uglerod, azot, pH)
  Future<SoilPropertiesResponseModel> getSoilFertility({
    required double latitude,
    required double longitude,
    List<String>? depths,
  });

  /// Tuproq suv saqlash xususiyatlarini olish
  Future<SoilPropertiesResponseModel> getSoilWaterProperties({
    required double latitude,
    required double longitude,
    List<String>? depths,
  });

  /// Barcha mavjud tuproq xususiyatlarini olish
  Future<SoilPropertiesResponseModel> getAllSoilProperties({
    required double latitude,
    required double longitude,
  });
}

/// SoilGridsRemoteDataSource implementatsiyasi
class SoilGridsRemoteDataSourceImpl implements SoilGridsRemoteDataSource {
  final Dio _dio;
  final NetworkInfo _networkInfo;

  SoilGridsRemoteDataSourceImpl({
    required NetworkInfo networkInfo,
    Dio? dio,
  })  : _networkInfo = networkInfo,
        _dio = dio ?? _createDio();

  /// Dio instance yaratish
  static Dio _createDio() {
    return Dio(
      BaseOptions(
        baseUrl: SoilGridsConstants.baseUrl,
        connectTimeout: Duration(seconds: SoilGridsConstants.connectTimeout),
        receiveTimeout: Duration(seconds: SoilGridsConstants.receiveTimeout),
        sendTimeout: Duration(seconds: SoilGridsConstants.sendTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  /// Internet ulanishini tekshirish
  Future<void> _checkConnection() async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      throw NetworkFailure.noConnection();
    }
  }

  @override
  Future<SoilPropertiesResponseModel> getSoilProperties({
    required double latitude,
    required double longitude,
    List<String>? properties,
    List<String>? depths,
    String valueType = 'mean',
  }) async {
    await _checkConnection();

    try {
      // Query parametrlarini tayyorlash
      final Map<String, dynamic> queryParams = {
        SoilGridsConstants.latitudeParam: latitude,
        SoilGridsConstants.longitudeParam: longitude,
      };

      // Agar properties berilgan bo'lsa
      if (properties != null && properties.isNotEmpty) {
        queryParams[SoilGridsConstants.propertyParam] = properties;
      }

      // Agar depths berilgan bo'lsa
      if (depths != null && depths.isNotEmpty) {
        queryParams[SoilGridsConstants.depthParam] = depths;
      }

      // Qiymat turi (mean, Q0.05, Q0.5, Q0.95)
      queryParams[SoilGridsConstants.valueParam] = valueType;

      final response = await _dio.get(
        SoilGridsConstants.propertiesQueryEndpoint,
        queryParameters: queryParams,
      );

      return SoilPropertiesResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<SoilPropertiesResponseModel> getSoilTexture({
    required double latitude,
    required double longitude,
    List<String>? depths,
  }) async {
    return getSoilProperties(
      latitude: latitude,
      longitude: longitude,
      properties: SoilGridsConstants.textureProperties,
      depths: depths ?? SoilGridsConstants.topsoilDepths,
    );
  }

  @override
  Future<SoilPropertiesResponseModel> getSoilFertility({
    required double latitude,
    required double longitude,
    List<String>? depths,
  }) async {
    return getSoilProperties(
      latitude: latitude,
      longitude: longitude,
      properties: SoilGridsConstants.fertilityProperties,
      depths: depths ?? SoilGridsConstants.topsoilDepths,
    );
  }

  @override
  Future<SoilPropertiesResponseModel> getSoilWaterProperties({
    required double latitude,
    required double longitude,
    List<String>? depths,
  }) async {
    return getSoilProperties(
      latitude: latitude,
      longitude: longitude,
      properties: SoilGridsConstants.waterProperties,
      depths: depths ?? SoilGridsConstants.allDepths,
    );
  }

  @override
  Future<SoilPropertiesResponseModel> getAllSoilProperties({
    required double latitude,
    required double longitude,
  }) async {
    return getSoilProperties(
      latitude: latitude,
      longitude: longitude,
      properties: SoilGridsConstants.allProperties,
      depths: SoilGridsConstants.allDepths,
    );
  }

  /// Dio xatolarini qayta ishlash
  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure.timeout();
      case DioExceptionType.connectionError:
        return NetworkFailure.connectionError();
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null) {
          // SoilGrids maxsus xatolarini qayta ishlash
          if (statusCode == 503) {
            return const ServerFailure(
              message: 'SoilGrids servisi vaqtincha mavjud emas. Keyinroq urinib ko\'ring.',
              statusCode: 503,
            );
          }
          if (statusCode == 404) {
            return const ServerFailure(
              message: 'Berilgan koordinatalarda ma\'lumot topilmadi.',
              statusCode: 404,
            );
          }
          return ServerFailure.fromStatusCode(statusCode);
        }
        return const ServerFailure(message: 'Server xatosi');
      case DioExceptionType.cancel:
        return const ServerFailure(message: 'So\'rov bekor qilindi');
      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
        return const UnknownFailure();
    }
  }
}


/// Request parametrlari uchun builder class
class SoilGridsRequestBuilder {
  double? _latitude;
  double? _longitude;
  final List<String> _properties = [];
  final List<String> _depths = [];
  String _valueType = 'mean';

  SoilGridsRequestBuilder setCoordinates(double lat, double lon) {
    _latitude = lat;
    _longitude = lon;
    return this;
  }

  SoilGridsRequestBuilder addProperty(String property) {
    if (SoilGridsConstants.allProperties.contains(property)) {
      _properties.add(property);
    }
    return this;
  }

  SoilGridsRequestBuilder addProperties(List<String> properties) {
    for (final property in properties) {
      addProperty(property);
    }
    return this;
  }

  SoilGridsRequestBuilder addDepth(String depth) {
    if (SoilGridsConstants.allDepths.contains(depth)) {
      _depths.add(depth);
    }
    return this;
  }

  SoilGridsRequestBuilder addDepths(List<String> depths) {
    for (final depth in depths) {
      addDepth(depth);
    }
    return this;
  }

  SoilGridsRequestBuilder setValueType(String valueType) {
    if (SoilGridsConstants.allValues.contains(valueType)) {
      _valueType = valueType;
    }
    return this;
  }

  /// Texture xususiyatlarini qo'shish
  SoilGridsRequestBuilder forTexture() {
    return addProperties(SoilGridsConstants.textureProperties);
  }

  /// Unumdorlik xususiyatlarini qo'shish
  SoilGridsRequestBuilder forFertility() {
    return addProperties(SoilGridsConstants.fertilityProperties);
  }

  /// Suv saqlash xususiyatlarini qo'shish
  SoilGridsRequestBuilder forWaterProperties() {
    return addProperties(SoilGridsConstants.waterProperties);
  }

  /// Yuza qatlamlarni qo'shish
  SoilGridsRequestBuilder forTopsoil() {
    return addDepths(SoilGridsConstants.topsoilDepths);
  }

  /// Barcha qatlamlarni qo'shish
  SoilGridsRequestBuilder forAllDepths() {
    return addDepths(SoilGridsConstants.allDepths);
  }

  /// So'rov parametrlarini build qilish
  Map<String, dynamic> build() {
    if (_latitude == null || _longitude == null) {
      throw ArgumentError('Latitude and longitude are required');
    }

    final Map<String, dynamic> params = {
      SoilGridsConstants.latitudeParam: _latitude,
      SoilGridsConstants.longitudeParam: _longitude,
    };

    if (_properties.isNotEmpty) {
      params[SoilGridsConstants.propertyParam] = _properties;
    }

    if (_depths.isNotEmpty) {
      params[SoilGridsConstants.depthParam] = _depths;
    }

    params[SoilGridsConstants.valueParam] = _valueType;

    return params;
  }
}
