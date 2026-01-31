import 'dart:convert';

import 'package:hive_ce/hive.dart';

import '../../../../core/di/injection_container.dart';
import '../models/weather_response_model.dart';
import '../models/soil_moisture_response_model.dart';

/// Weather ma'lumotlarini lokal saqlash uchun Data Source
abstract class WeatherLocalDataSource {
  /// Ob-havo ma'lumotlarini keshga saqlash
  Future<void> cacheWeather({
    required double latitude,
    required double longitude,
    required WeatherResponseModel weather,
  });

  /// Keshdan ob-havo ma'lumotlarini olish
  Future<WeatherResponseModel?> getCachedWeather({
    required double latitude,
    required double longitude,
  });

  /// Ob-havo keshi mavjud va yangi ekanligini tekshirish
  bool isWeatherCacheValid({
    required double latitude,
    required double longitude,
  });

  /// Tuproq namligi ma'lumotlarini keshga saqlash
  Future<void> cacheSoilMoisture({
    required double latitude,
    required double longitude,
    required SoilMoistureResponseModel soilMoisture,
  });

  /// Keshdan tuproq namligi ma'lumotlarini olish
  Future<SoilMoistureResponseModel?> getCachedSoilMoisture({
    required double latitude,
    required double longitude,
  });

  /// Tuproq namligi keshi mavjud va yangi ekanligini tekshirish
  bool isSoilMoistureCacheValid({
    required double latitude,
    required double longitude,
  });

  /// Barcha keshni tozalash
  Future<void> clearAll();
}

/// WeatherLocalDataSource implementatsiyasi
class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final Box<dynamic> weatherBox;
  final Box<dynamic> soilMoistureBox;

  WeatherLocalDataSourceImpl({
    required this.weatherBox,
    required this.soilMoistureBox,
  });

  @override
  Future<void> cacheWeather({
    required double latitude,
    required double longitude,
    required WeatherResponseModel weather,
  }) async {
    final key = StorageKeys.weatherKey(latitude, longitude);
    final timestampKey = StorageKeys.weatherTimestamp(latitude, longitude);
    
    // JSON ga aylantirish va saqlash
    final jsonData = jsonEncode(weather.toJson());
    await weatherBox.put(key, jsonData);
    await weatherBox.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Future<WeatherResponseModel?> getCachedWeather({
    required double latitude,
    required double longitude,
  }) async {
    final key = StorageKeys.weatherKey(latitude, longitude);
    final jsonData = weatherBox.get(key);
    
    if (jsonData == null) return null;
    
    try {
      final Map<String, dynamic> json = jsonDecode(jsonData as String);
      return WeatherResponseModel.fromJson(json);
    } catch (e) {
      // Parse xatosi bo'lsa null qaytarish
      return null;
    }
  }

  @override
  bool isWeatherCacheValid({
    required double latitude,
    required double longitude,
  }) {
    final timestampKey = StorageKeys.weatherTimestamp(latitude, longitude);
    final timestamp = weatherBox.get(timestampKey) as int?;
    
    if (timestamp == null) return false;
    
    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - timestamp) < StorageKeys.weatherCacheDuration;
  }

  @override
  Future<void> cacheSoilMoisture({
    required double latitude,
    required double longitude,
    required SoilMoistureResponseModel soilMoisture,
  }) async {
    final key = StorageKeys.soilMoistureKey(latitude, longitude);
    final timestampKey = StorageKeys.soilMoistureTimestamp(latitude, longitude);
    
    final jsonData = jsonEncode(soilMoisture.toJson());
    await soilMoistureBox.put(key, jsonData);
    await soilMoistureBox.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Future<SoilMoistureResponseModel?> getCachedSoilMoisture({
    required double latitude,
    required double longitude,
  }) async {
    final key = StorageKeys.soilMoistureKey(latitude, longitude);
    final jsonData = soilMoistureBox.get(key);
    
    if (jsonData == null) return null;
    
    try {
      final Map<String, dynamic> json = jsonDecode(jsonData as String);
      return SoilMoistureResponseModel.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  bool isSoilMoistureCacheValid({
    required double latitude,
    required double longitude,
  }) {
    final timestampKey = StorageKeys.soilMoistureTimestamp(latitude, longitude);
    final timestamp = soilMoistureBox.get(timestampKey) as int?;
    
    if (timestamp == null) return false;
    
    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - timestamp) < StorageKeys.soilMoistureCacheDuration;
  }

  @override
  Future<void> clearAll() async {
    await weatherBox.clear();
    await soilMoistureBox.clear();
  }
}
