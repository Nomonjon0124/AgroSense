import 'package:dio/dio.dart';


import '../../../../core/constants/open_meteo_constants.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/error/faliures.dart';
import '../models/weather_response_model.dart';
import '../models/soil_moisture_response_model.dart';

/// Open-Meteo API bilan ishlash uchun Remote Data Source
/// Ob-havo va tuproq namligi ma'lumotlarini olish
abstract class OpenMeteoRemoteDataSource {
  /// Joriy ob-havo ma'lumotlarini olish
  Future<WeatherResponseModel> getCurrentWeather({
    required double latitude,
    required double longitude,
    String? timezone,
  });

  /// Soatlik ob-havo prognozini olish
  Future<WeatherResponseModel> getHourlyForecast({
    required double latitude,
    required double longitude,
    int forecastDays = 7,
    String? timezone,
  });

  /// Kunlik ob-havo prognozini olish
  Future<WeatherResponseModel> getDailyForecast({
    required double latitude,
    required double longitude,
    int forecastDays = 7,
    String? timezone,
  });

  /// To'liq ob-havo ma'lumotlarini olish (joriy + soatlik + kunlik)
  Future<WeatherResponseModel> getFullWeatherData({
    required double latitude,
    required double longitude,
    int forecastDays = 7,
    String? timezone,
  });

  /// Tuproq namligi ma'lumotlarini olish
  Future<SoilMoistureResponseModel> getSoilMoisture({
    required double latitude,
    required double longitude,
    int forecastDays = 7,
    String? timezone,
  });

  /// Tarixiy ob-havo ma'lumotlarini olish
  Future<WeatherResponseModel> getHistoricalWeather({
    required double latitude,
    required double longitude,
    required DateTime startDate,
    required DateTime endDate,
    String? timezone,
  });
}

/// OpenMeteoRemoteDataSource implementatsiyasi
class OpenMeteoRemoteDataSourceImpl implements OpenMeteoRemoteDataSource {
  final Dio _dio;
  final NetworkInfo _networkInfo;

  OpenMeteoRemoteDataSourceImpl({
    required NetworkInfo networkInfo,
    Dio? dio,
  })  : _networkInfo = networkInfo,
        _dio = dio ?? _createDio();

  /// Dio instance yaratish
  static Dio _createDio() {
    return Dio(
      BaseOptions(
        baseUrl: OpenMeteoConstants.baseUrl,
        connectTimeout: Duration(seconds: OpenMeteoConstants.connectTimeout),
        receiveTimeout: Duration(seconds: OpenMeteoConstants.receiveTimeout),
        sendTimeout: Duration(seconds: OpenMeteoConstants.sendTimeout),
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
  Future<WeatherResponseModel> getCurrentWeather({
    required double latitude,
    required double longitude,
    String? timezone,
  }) async {
    await _checkConnection();

    try {
      final response = await _dio.get(
        OpenMeteoConstants.forecastEndpoint,
        queryParameters: {
          OpenMeteoConstants.latitudeParam: latitude,
          OpenMeteoConstants.longitudeParam: longitude,
          OpenMeteoConstants.timezoneParam: timezone ?? 'auto',
          OpenMeteoConstants.currentParam: OpenMeteoConstants.currentWeatherVariables.join(','),
        },
      );

      return WeatherResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<WeatherResponseModel> getHourlyForecast({
    required double latitude,
    required double longitude,
    int forecastDays = 7,
    String? timezone,
  }) async {
    await _checkConnection();

    try {
      final response = await _dio.get(
        OpenMeteoConstants.forecastEndpoint,
        queryParameters: {
          OpenMeteoConstants.latitudeParam: latitude,
          OpenMeteoConstants.longitudeParam: longitude,
          OpenMeteoConstants.timezoneParam: timezone ?? 'auto',
          OpenMeteoConstants.forecastDaysParam: forecastDays,
          OpenMeteoConstants.hourlyParam: [
            'temperature_2m',
            'relative_humidity_2m',
            'apparent_temperature',
            'precipitation_probability',
            'precipitation',
            'weather_code',
            'cloud_cover',
            'visibility',
            'wind_speed_10m',
            'wind_direction_10m',
            'uv_index',
            'is_day',
          ].join(','),
        },
      );

      return WeatherResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<WeatherResponseModel> getDailyForecast({
    required double latitude,
    required double longitude,
    int forecastDays = 7,
    String? timezone,
  }) async {
    await _checkConnection();

    try {
      final response = await _dio.get(
        OpenMeteoConstants.forecastEndpoint,
        queryParameters: {
          OpenMeteoConstants.latitudeParam: latitude,
          OpenMeteoConstants.longitudeParam: longitude,
          OpenMeteoConstants.timezoneParam: timezone ?? 'auto',
          OpenMeteoConstants.forecastDaysParam: forecastDays,
          OpenMeteoConstants.dailyParam: [
            'weather_code',
            'temperature_2m_max',
            'temperature_2m_min',
            'sunrise',
            'sunset',
            'daylight_duration',
            'sunshine_duration',
            'uv_index_max',
            'precipitation_sum',
            'precipitation_probability_max',
            'wind_speed_10m_max',
            'wind_gusts_10m_max',
            'wind_direction_10m_dominant',
          ].join(','),
        },
      );

      return WeatherResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<WeatherResponseModel> getFullWeatherData({
    required double latitude,
    required double longitude,
    int forecastDays = 7,
    String? timezone,
  }) async {
    await _checkConnection();

    try {
      final response = await _dio.get(
        OpenMeteoConstants.forecastEndpoint,
        queryParameters: {
          OpenMeteoConstants.latitudeParam: latitude,
          OpenMeteoConstants.longitudeParam: longitude,
          OpenMeteoConstants.timezoneParam: timezone ?? 'auto',
          OpenMeteoConstants.forecastDaysParam: forecastDays,
          // Joriy ob-havo
          OpenMeteoConstants.currentParam: OpenMeteoConstants.currentWeatherVariables.join(','),
          // Soatlik prognoz
          OpenMeteoConstants.hourlyParam: [
            'temperature_2m',
            'relative_humidity_2m',
            'apparent_temperature',
            'precipitation_probability',
            'precipitation',
            'weather_code',
            'cloud_cover',
            'visibility',
            'wind_speed_10m',
            'wind_direction_10m',
            'uv_index',
            'is_day',
          ].join(','),
          // Kunlik prognoz
          OpenMeteoConstants.dailyParam: [
            'weather_code',
            'temperature_2m_max',
            'temperature_2m_min',
            'sunrise',
            'sunset',
            'daylight_duration',
            'sunshine_duration',
            'uv_index_max',
            'precipitation_sum',
            'precipitation_probability_max',
            'wind_speed_10m_max',
            'wind_gusts_10m_max',
            'wind_direction_10m_dominant',
          ].join(','),
        },
      );

      return WeatherResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<SoilMoistureResponseModel> getSoilMoisture({
    required double latitude,
    required double longitude,
    int forecastDays = 7,
    String? timezone,
  }) async {
    await _checkConnection();

    try {
      final response = await _dio.get(
        OpenMeteoConstants.forecastEndpoint,
        queryParameters: {
          OpenMeteoConstants.latitudeParam: latitude,
          OpenMeteoConstants.longitudeParam: longitude,
          OpenMeteoConstants.timezoneParam: timezone ?? 'auto',
          OpenMeteoConstants.forecastDaysParam: forecastDays,
          OpenMeteoConstants.hourlyParam: OpenMeteoConstants.hourlySoilMoistureVariables.join(','),
        },
      );

      return SoilMoistureResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<WeatherResponseModel> getHistoricalWeather({
    required double latitude,
    required double longitude,
    required DateTime startDate,
    required DateTime endDate,
    String? timezone,
  }) async {
    await _checkConnection();

    try {
      final response = await _dio.get(
        OpenMeteoConstants.forecastEndpoint,
        queryParameters: {
          OpenMeteoConstants.latitudeParam: latitude,
          OpenMeteoConstants.longitudeParam: longitude,
          OpenMeteoConstants.timezoneParam: timezone ?? 'auto',
          OpenMeteoConstants.startDateParam: _formatDate(startDate),
          OpenMeteoConstants.endDateParam: _formatDate(endDate),
          OpenMeteoConstants.hourlyParam: [
            'temperature_2m',
            'relative_humidity_2m',
            'precipitation',
            'weather_code',
            'wind_speed_10m',
          ].join(','),
          OpenMeteoConstants.dailyParam: [
            'weather_code',
            'temperature_2m_max',
            'temperature_2m_min',
            'precipitation_sum',
          ].join(','),
        },
      );

      return WeatherResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Sana formatini aylantirish
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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
