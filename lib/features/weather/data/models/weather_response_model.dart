import '../../domain/entities/weather_entity.dart';

/// Open-Meteo API'dan keluvchi ob-havo javob modeli
class WeatherResponseModel {
  final double latitude;
  final double longitude;
  final double elevation;
  final double generationtimeMs;
  final int utcOffsetSeconds;
  final String timezone;
  final String timezoneAbbreviation;
  final CurrentWeatherModel? current;
  final HourlyWeatherModel? hourly;
  final DailyWeatherModel? daily;

  WeatherResponseModel({
    required this.latitude,
    required this.longitude,
    required this.elevation,
    required this.generationtimeMs,
    required this.utcOffsetSeconds,
    required this.timezone,
    required this.timezoneAbbreviation,
    this.current,
    this.hourly,
    this.daily,
  });

  factory WeatherResponseModel.fromJson(Map<String, dynamic> json) {
    return WeatherResponseModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      elevation: (json['elevation'] as num?)?.toDouble() ?? 0.0,
      generationtimeMs: (json['generationtime_ms'] as num?)?.toDouble() ?? 0.0,
      utcOffsetSeconds: json['utc_offset_seconds'] as int? ?? 0,
      timezone: json['timezone'] as String? ?? 'UTC',
      timezoneAbbreviation: json['timezone_abbreviation'] as String? ?? 'UTC',
      current: json['current'] != null
          ? CurrentWeatherModel.fromJson(json['current'] as Map<String, dynamic>)
          : null,
      hourly: json['hourly'] != null
          ? HourlyWeatherModel.fromJson(json['hourly'] as Map<String, dynamic>)
          : null,
      daily: json['daily'] != null
          ? DailyWeatherModel.fromJson(json['daily'] as Map<String, dynamic>)
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
      'current': current?.toJson(),
      'hourly': hourly?.toJson(),
      'daily': daily?.toJson(),
    };
  }

  /// Entity'ga aylantirish
  WeatherEntity toEntity() {
    return WeatherEntity(
      latitude: latitude,
      longitude: longitude,
      elevation: elevation,
      timezone: timezone,
      currentWeather: current?.toEntity(),
      hourlyWeather: hourly?.toEntity(),
      dailyWeather: daily?.toEntity(),
    );
  }
}

/// Joriy ob-havo modeli
class CurrentWeatherModel {
  final String time;
  final int interval;
  final double temperature2m;
  final int relativeHumidity2m;
  final double apparentTemperature;
  final int isDay;
  final double precipitation;
  final double rain;
  final double showers;
  final double snowfall;
  final int weatherCode;
  final int cloudCover;
  final double pressureMsl;
  final double surfacePressure;
  final double windSpeed10m;
  final int windDirection10m;
  final double windGusts10m;

  CurrentWeatherModel({
    required this.time,
    required this.interval,
    required this.temperature2m,
    required this.relativeHumidity2m,
    required this.apparentTemperature,
    required this.isDay,
    required this.precipitation,
    required this.rain,
    required this.showers,
    required this.snowfall,
    required this.weatherCode,
    required this.cloudCover,
    required this.pressureMsl,
    required this.surfacePressure,
    required this.windSpeed10m,
    required this.windDirection10m,
    required this.windGusts10m,
  });

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(
      time: json['time'] as String? ?? '',
      interval: json['interval'] as int? ?? 900,
      temperature2m: (json['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      relativeHumidity2m: json['relative_humidity_2m'] as int? ?? 0,
      apparentTemperature: (json['apparent_temperature'] as num?)?.toDouble() ?? 0.0,
      isDay: json['is_day'] as int? ?? 1,
      precipitation: (json['precipitation'] as num?)?.toDouble() ?? 0.0,
      rain: (json['rain'] as num?)?.toDouble() ?? 0.0,
      showers: (json['showers'] as num?)?.toDouble() ?? 0.0,
      snowfall: (json['snowfall'] as num?)?.toDouble() ?? 0.0,
      weatherCode: json['weather_code'] as int? ?? 0,
      cloudCover: json['cloud_cover'] as int? ?? 0,
      pressureMsl: (json['pressure_msl'] as num?)?.toDouble() ?? 0.0,
      surfacePressure: (json['surface_pressure'] as num?)?.toDouble() ?? 0.0,
      windSpeed10m: (json['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
      windDirection10m: json['wind_direction_10m'] as int? ?? 0,
      windGusts10m: (json['wind_gusts_10m'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'interval': interval,
      'temperature_2m': temperature2m,
      'relative_humidity_2m': relativeHumidity2m,
      'apparent_temperature': apparentTemperature,
      'is_day': isDay,
      'precipitation': precipitation,
      'rain': rain,
      'showers': showers,
      'snowfall': snowfall,
      'weather_code': weatherCode,
      'cloud_cover': cloudCover,
      'pressure_msl': pressureMsl,
      'surface_pressure': surfacePressure,
      'wind_speed_10m': windSpeed10m,
      'wind_direction_10m': windDirection10m,
      'wind_gusts_10m': windGusts10m,
    };
  }

  CurrentWeatherEntity toEntity() {
    return CurrentWeatherEntity(
      time: DateTime.parse(time),
      temperature: temperature2m,
      relativeHumidity: relativeHumidity2m,
      apparentTemperature: apparentTemperature,
      isDay: isDay == 1,
      precipitation: precipitation,
      rain: rain,
      showers: showers,
      snowfall: snowfall,
      weatherCode: weatherCode,
      cloudCover: cloudCover,
      pressureMsl: pressureMsl,
      surfacePressure: surfacePressure,
      windSpeed: windSpeed10m,
      windDirection: windDirection10m,
      windGusts: windGusts10m,
    );
  }
}

/// Soatlik ob-havo modeli
class HourlyWeatherModel {
  final List<String> time;
  final List<double> temperature2m;
  final List<int> relativeHumidity2m;
  final List<double> apparentTemperature;
  final List<int> precipitationProbability;
  final List<double> precipitation;
  final List<int> weatherCode;
  final List<int> cloudCover;
  final List<double> visibility;
  final List<double> windSpeed10m;
  final List<int> windDirection10m;
  final List<double> uvIndex;
  final List<int> isDay;

  HourlyWeatherModel({
    required this.time,
    required this.temperature2m,
    required this.relativeHumidity2m,
    required this.apparentTemperature,
    required this.precipitationProbability,
    required this.precipitation,
    required this.weatherCode,
    required this.cloudCover,
    required this.visibility,
    required this.windSpeed10m,
    required this.windDirection10m,
    required this.uvIndex,
    required this.isDay,
  });

  factory HourlyWeatherModel.fromJson(Map<String, dynamic> json) {
    return HourlyWeatherModel(
      time: (json['time'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      temperature2m: _parseDoubleList(json['temperature_2m']),
      relativeHumidity2m: _parseIntList(json['relative_humidity_2m']),
      apparentTemperature: _parseDoubleList(json['apparent_temperature']),
      precipitationProbability: _parseIntList(json['precipitation_probability']),
      precipitation: _parseDoubleList(json['precipitation']),
      weatherCode: _parseIntList(json['weather_code']),
      cloudCover: _parseIntList(json['cloud_cover']),
      visibility: _parseDoubleList(json['visibility']),
      windSpeed10m: _parseDoubleList(json['wind_speed_10m']),
      windDirection10m: _parseIntList(json['wind_direction_10m']),
      uvIndex: _parseDoubleList(json['uv_index']),
      isDay: _parseIntList(json['is_day']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'temperature_2m': temperature2m,
      'relative_humidity_2m': relativeHumidity2m,
      'apparent_temperature': apparentTemperature,
      'precipitation_probability': precipitationProbability,
      'precipitation': precipitation,
      'weather_code': weatherCode,
      'cloud_cover': cloudCover,
      'visibility': visibility,
      'wind_speed_10m': windSpeed10m,
      'wind_direction_10m': windDirection10m,
      'uv_index': uvIndex,
      'is_day': isDay,
    };
  }

  HourlyWeatherEntity toEntity() {
    return HourlyWeatherEntity(
      time: time.map((t) => DateTime.parse(t)).toList(),
      temperature: temperature2m,
      relativeHumidity: relativeHumidity2m,
      apparentTemperature: apparentTemperature,
      precipitationProbability: precipitationProbability,
      precipitation: precipitation,
      weatherCode: weatherCode,
      cloudCover: cloudCover,
      visibility: visibility,
      windSpeed: windSpeed10m,
      windDirection: windDirection10m,
      uvIndex: uvIndex,
      isDay: isDay.map((i) => i == 1).toList(),
    );
  }
}

/// Kunlik ob-havo modeli
class DailyWeatherModel {
  final List<String> time;
  final List<int> weatherCode;
  final List<double> temperature2mMax;
  final List<double> temperature2mMin;
  final List<String> sunrise;
  final List<String> sunset;
  final List<double> daylightDuration;
  final List<double> sunshineDuration;
  final List<double> uvIndexMax;
  final List<double> precipitationSum;
  final List<int> precipitationProbabilityMax;
  final List<double> windSpeed10mMax;
  final List<double> windGusts10mMax;
  final List<int> windDirection10mDominant;

  DailyWeatherModel({
    required this.time,
    required this.weatherCode,
    required this.temperature2mMax,
    required this.temperature2mMin,
    required this.sunrise,
    required this.sunset,
    required this.daylightDuration,
    required this.sunshineDuration,
    required this.uvIndexMax,
    required this.precipitationSum,
    required this.precipitationProbabilityMax,
    required this.windSpeed10mMax,
    required this.windGusts10mMax,
    required this.windDirection10mDominant,
  });

  factory DailyWeatherModel.fromJson(Map<String, dynamic> json) {
    return DailyWeatherModel(
      time: (json['time'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      weatherCode: _parseIntList(json['weather_code']),
      temperature2mMax: _parseDoubleList(json['temperature_2m_max']),
      temperature2mMin: _parseDoubleList(json['temperature_2m_min']),
      sunrise: (json['sunrise'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      sunset: (json['sunset'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      daylightDuration: _parseDoubleList(json['daylight_duration']),
      sunshineDuration: _parseDoubleList(json['sunshine_duration']),
      uvIndexMax: _parseDoubleList(json['uv_index_max']),
      precipitationSum: _parseDoubleList(json['precipitation_sum']),
      precipitationProbabilityMax: _parseIntList(json['precipitation_probability_max']),
      windSpeed10mMax: _parseDoubleList(json['wind_speed_10m_max']),
      windGusts10mMax: _parseDoubleList(json['wind_gusts_10m_max']),
      windDirection10mDominant: _parseIntList(json['wind_direction_10m_dominant']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'weather_code': weatherCode,
      'temperature_2m_max': temperature2mMax,
      'temperature_2m_min': temperature2mMin,
      'sunrise': sunrise,
      'sunset': sunset,
      'daylight_duration': daylightDuration,
      'sunshine_duration': sunshineDuration,
      'uv_index_max': uvIndexMax,
      'precipitation_sum': precipitationSum,
      'precipitation_probability_max': precipitationProbabilityMax,
      'wind_speed_10m_max': windSpeed10mMax,
      'wind_gusts_10m_max': windGusts10mMax,
      'wind_direction_10m_dominant': windDirection10mDominant,
    };
  }

  DailyWeatherEntity toEntity() {
    return DailyWeatherEntity(
      time: time.map((t) => DateTime.parse(t)).toList(),
      weatherCode: weatherCode,
      temperatureMax: temperature2mMax,
      temperatureMin: temperature2mMin,
      sunrise: sunrise.map((s) => DateTime.parse(s)).toList(),
      sunset: sunset.map((s) => DateTime.parse(s)).toList(),
      daylightDuration: daylightDuration,
      sunshineDuration: sunshineDuration,
      uvIndexMax: uvIndexMax,
      precipitationSum: precipitationSum,
      precipitationProbabilityMax: precipitationProbabilityMax,
      windSpeedMax: windSpeed10mMax,
      windGustsMax: windGusts10mMax,
      windDirectionDominant: windDirection10mDominant,
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

// Helper function: List dynamic ni List int ga aylantirish
List<int> _parseIntList(dynamic data) {
  if (data == null) return [];
  return (data as List<dynamic>)
      .map((e) => e != null ? (e as num).toInt() : 0)
      .toList();
}
