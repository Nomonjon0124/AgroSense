import 'dart:convert';

import 'package:hive_ce/hive.dart';

import '../../../../core/di/injection_container.dart';
import '../models/soil_properties_response_model.dart';

/// Tuproq xususiyatlari ma'lumotlarini lokal saqlash uchun Data Source
abstract class SoilPropertiesLocalDataSource {
  /// Tuproq xususiyatlarini keshga saqlash
  Future<void> cacheSoilProperties({
    required double latitude,
    required double longitude,
    required SoilPropertiesResponseModel properties,
  });

  /// Keshdan tuproq xususiyatlarini olish
  Future<SoilPropertiesResponseModel?> getCachedSoilProperties({
    required double latitude,
    required double longitude,
  });

  /// Tuproq xususiyatlari keshi mavjud va yangi ekanligini tekshirish
  bool isCacheValid({
    required double latitude,
    required double longitude,
  });

  /// Keshni tozalash
  Future<void> clearAll();
}

/// SoilPropertiesLocalDataSource implementatsiyasi
class SoilPropertiesLocalDataSourceImpl implements SoilPropertiesLocalDataSource {
  final Box<dynamic> soilPropertiesBox;

  SoilPropertiesLocalDataSourceImpl({
    required this.soilPropertiesBox,
  });

  @override
  Future<void> cacheSoilProperties({
    required double latitude,
    required double longitude,
    required SoilPropertiesResponseModel properties,
  }) async {
    final key = StorageKeys.soilPropertiesKey(latitude, longitude);
    final timestampKey = StorageKeys.soilPropertiesTimestamp(latitude, longitude);
    
    final jsonData = jsonEncode(properties.toJson());
    await soilPropertiesBox.put(key, jsonData);
    await soilPropertiesBox.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Future<SoilPropertiesResponseModel?> getCachedSoilProperties({
    required double latitude,
    required double longitude,
  }) async {
    final key = StorageKeys.soilPropertiesKey(latitude, longitude);
    final jsonData = soilPropertiesBox.get(key);
    
    if (jsonData == null) return null;
    
    try {
      final Map<String, dynamic> json = jsonDecode(jsonData as String);
      return SoilPropertiesResponseModel.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  bool isCacheValid({
    required double latitude,
    required double longitude,
  }) {
    final timestampKey = StorageKeys.soilPropertiesTimestamp(latitude, longitude);
    final timestamp = soilPropertiesBox.get(timestampKey) as int?;
    
    if (timestamp == null) return false;
    
    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - timestamp) < StorageKeys.soilPropertiesCacheDuration;
  }

  @override
  Future<void> clearAll() async {
    await soilPropertiesBox.clear();
  }
}
