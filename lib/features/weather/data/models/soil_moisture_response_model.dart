import '../../domain/entities/soil_moisture_entity.dart';

/// Open-Meteo API'dan keluvchi tuproq namligi javob modeli
class SoilMoistureResponseModel {
  final double latitude;
  final double longitude;
  final double elevation;
  final double generationtimeMs;
  final int utcOffsetSeconds;
  final String timezone;
  final String timezoneAbbreviation;
  final HourlySoilMoistureModel? hourly;

  SoilMoistureResponseModel({
    required this.latitude,
    required this.longitude,
    required this.elevation,
    required this.generationtimeMs,
    required this.utcOffsetSeconds,
    required this.timezone,
    required this.timezoneAbbreviation,
    this.hourly,
  });

  factory SoilMoistureResponseModel.fromJson(Map<String, dynamic> json) {
    return SoilMoistureResponseModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      elevation: (json['elevation'] as num?)?.toDouble() ?? 0.0,
      generationtimeMs: (json['generationtime_ms'] as num?)?.toDouble() ?? 0.0,
      utcOffsetSeconds: json['utc_offset_seconds'] as int? ?? 0,
      timezone: json['timezone'] as String? ?? 'UTC',
      timezoneAbbreviation: json['timezone_abbreviation'] as String? ?? 'UTC',
      hourly: json['hourly'] != null
          ? HourlySoilMoistureModel.fromJson(json['hourly'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'elevation': elevation,
      'generationtime_ms': generationtimeMs,
      'utc_offset_seconds': utcOffsetSeconds,
      'timezone': timezone,
      'timezone_abbreviation': timezoneAbbreviation,
      'hourly': hourly?.toJson(),
    };
  }

  /// Entity'ga aylantirish
  SoilMoistureEntity toEntity() {
    return SoilMoistureEntity(
      latitude: latitude,
      longitude: longitude,
      elevation: elevation,
      timezone: timezone,
      hourlySoilMoisture: hourly?.toEntity(),
    );
  }
}

/// Soatlik tuproq namligi modeli
class HourlySoilMoistureModel {
  final List<String> time;
  final List<double> soilTemperature0cm;
  final List<double> soilTemperature6cm;
  final List<double> soilTemperature18cm;
  final List<double> soilTemperature54cm;
  final List<double> soilMoisture0to1cm;
  final List<double> soilMoisture1to3cm;
  final List<double> soilMoisture3to9cm;
  final List<double> soilMoisture9to27cm;
  final List<double> soilMoisture27to81cm;

  HourlySoilMoistureModel({
    required this.time,
    required this.soilTemperature0cm,
    required this.soilTemperature6cm,
    required this.soilTemperature18cm,
    required this.soilTemperature54cm,
    required this.soilMoisture0to1cm,
    required this.soilMoisture1to3cm,
    required this.soilMoisture3to9cm,
    required this.soilMoisture9to27cm,
    required this.soilMoisture27to81cm,
  });

  factory HourlySoilMoistureModel.fromJson(Map<String, dynamic> json) {
    return HourlySoilMoistureModel(
      time: (json['time'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      soilTemperature0cm: _parseDoubleList(json['soil_temperature_0cm']),
      soilTemperature6cm: _parseDoubleList(json['soil_temperature_6cm']),
      soilTemperature18cm: _parseDoubleList(json['soil_temperature_18cm']),
      soilTemperature54cm: _parseDoubleList(json['soil_temperature_54cm']),
      soilMoisture0to1cm: _parseDoubleList(json['soil_moisture_0_to_1cm']),
      soilMoisture1to3cm: _parseDoubleList(json['soil_moisture_1_to_3cm']),
      soilMoisture3to9cm: _parseDoubleList(json['soil_moisture_3_to_9cm']),
      soilMoisture9to27cm: _parseDoubleList(json['soil_moisture_9_to_27cm']),
      soilMoisture27to81cm: _parseDoubleList(json['soil_moisture_27_to_81cm']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'soil_temperature_0cm': soilTemperature0cm,
      'soil_temperature_6cm': soilTemperature6cm,
      'soil_temperature_18cm': soilTemperature18cm,
      'soil_temperature_54cm': soilTemperature54cm,
      'soil_moisture_0_to_1cm': soilMoisture0to1cm,
      'soil_moisture_1_to_3cm': soilMoisture1to3cm,
      'soil_moisture_3_to_9cm': soilMoisture3to9cm,
      'soil_moisture_9_to_27cm': soilMoisture9to27cm,
      'soil_moisture_27_to_81cm': soilMoisture27to81cm,
    };
  }

  HourlySoilMoistureEntity toEntity() {
    return HourlySoilMoistureEntity(
      time: time.map((t) => DateTime.parse(t)).toList(),
      soilTemperature0cm: soilTemperature0cm,
      soilTemperature6cm: soilTemperature6cm,
      soilTemperature18cm: soilTemperature18cm,
      soilTemperature54cm: soilTemperature54cm,
      soilMoisture0to1cm: soilMoisture0to1cm,
      soilMoisture1to3cm: soilMoisture1to3cm,
      soilMoisture3to9cm: soilMoisture3to9cm,
      soilMoisture9to27cm: soilMoisture9to27cm,
      soilMoisture27to81cm: soilMoisture27to81cm,
    );
  }
}

// Helper function: List dynamic ni List double ga aylantirish
List<double> _parseDoubleList(dynamic data) {
  if (data == null) return [];
  return (data as List<dynamic>)
      .map((e) => e != null ? (e as num).toDouble() : 0.0)
      .toList();
}
