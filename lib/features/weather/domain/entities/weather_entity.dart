import 'package:equatable/equatable.dart';

/// Ob-havo Entity - Domain qatlam uchun
class WeatherEntity extends Equatable {
  /// Geografik kengligi
  final double latitude;
  
  /// Geografik uzunligi
  final double longitude;
  
  /// Balandlik (metr)
  final double elevation;
  
  /// Vaqt zonasi
  final String timezone;
  
  /// Joriy ob-havo ma'lumotlari
  final CurrentWeatherEntity? currentWeather;
  
  /// Soatlik ob-havo ma'lumotlari
  final HourlyWeatherEntity? hourlyWeather;
  
  /// Kunlik ob-havo ma'lumotlari
  final DailyWeatherEntity? dailyWeather;

  const WeatherEntity({
    required this.latitude,
    required this.longitude,
    required this.elevation,
    required this.timezone,
    this.currentWeather,
    this.hourlyWeather,
    this.dailyWeather,
  });

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        elevation,
        timezone,
        currentWeather,
        hourlyWeather,
        dailyWeather,
      ];
}

/// Joriy ob-havo Entity
class CurrentWeatherEntity extends Equatable {
  /// Vaqt
  final DateTime time;
  
  /// Harorat (°C)
  final double temperature;
  
  /// Nisbiy namlik (%)
  final int relativeHumidity;
  
  /// Sezilgan harorat (°C)
  final double apparentTemperature;
  
  /// Kunduzmi (true = kunduz)
  final bool isDay;
  
  /// Yog'ingarchilik (mm)
  final double precipitation;
  
  /// Yomg'ir (mm)
  final double rain;
  
  /// Jala (mm)
  final double showers;
  
  /// Qor (cm)
  final double snowfall;
  
  /// WMO ob-havo kodi
  final int weatherCode;
  
  /// Bulutlilik (%)
  final int cloudCover;
  
  /// Dengiz sathi bosimi (hPa)
  final double pressureMsl;
  
  /// Sirt bosimi (hPa)
  final double surfacePressure;
  
  /// Shamol tezligi (km/s)
  final double windSpeed;
  
  /// Shamol yo'nalishi (°)
  final int windDirection;
  
  /// Shamol gust (km/s)
  final double windGusts;

  const CurrentWeatherEntity({
    required this.time,
    required this.temperature,
    required this.relativeHumidity,
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
    required this.windSpeed,
    required this.windDirection,
    required this.windGusts,
  });

  @override
  List<Object?> get props => [
        time,
        temperature,
        relativeHumidity,
        apparentTemperature,
        isDay,
        precipitation,
        rain,
        showers,
        snowfall,
        weatherCode,
        cloudCover,
        pressureMsl,
        surfacePressure,
        windSpeed,
        windDirection,
        windGusts,
      ];
}

/// Soatlik ob-havo Entity
class HourlyWeatherEntity extends Equatable {
  /// Vaqtlar ro'yxati
  final List<DateTime> time;
  
  /// Haroratlar (°C)
  final List<double> temperature;
  
  /// Nisbiy namlik (%)
  final List<int> relativeHumidity;
  
  /// Sezilgan harorat (°C)
  final List<double> apparentTemperature;
  
  /// Yog'ingarchilik ehtimoli (%)
  final List<int> precipitationProbability;
  
  /// Yog'ingarchilik (mm)
  final List<double> precipitation;
  
  /// WMO ob-havo kodi
  final List<int> weatherCode;
  
  /// Bulutlilik (%)
  final List<int> cloudCover;
  
  /// Ko'rinish masofasi (m)
  final List<double> visibility;
  
  /// Shamol tezligi (km/s)
  final List<double> windSpeed;
  
  /// Shamol yo'nalishi (°)
  final List<int> windDirection;
  
  /// UV indeksi
  final List<double> uvIndex;
  
  /// Kunduzmi
  final List<bool> isDay;

  const HourlyWeatherEntity({
    required this.time,
    required this.temperature,
    required this.relativeHumidity,
    required this.apparentTemperature,
    required this.precipitationProbability,
    required this.precipitation,
    required this.weatherCode,
    required this.cloudCover,
    required this.visibility,
    required this.windSpeed,
    required this.windDirection,
    required this.uvIndex,
    required this.isDay,
  });

  @override
  List<Object?> get props => [
        time,
        temperature,
        relativeHumidity,
        apparentTemperature,
        precipitationProbability,
        precipitation,
        weatherCode,
        cloudCover,
        visibility,
        windSpeed,
        windDirection,
        uvIndex,
        isDay,
      ];

  /// Ma'lum soat uchun ob-havo olish
  HourlyWeatherSnapshot? getSnapshotAt(int index) {
    if (index < 0 || index >= time.length) return null;
    
    return HourlyWeatherSnapshot(
      time: time[index],
      temperature: temperature[index],
      relativeHumidity: relativeHumidity[index],
      apparentTemperature: apparentTemperature[index],
      precipitationProbability: precipitationProbability[index],
      precipitation: precipitation[index],
      weatherCode: weatherCode[index],
      cloudCover: cloudCover[index],
      visibility: visibility[index],
      windSpeed: windSpeed[index],
      windDirection: windDirection[index],
      uvIndex: uvIndex[index],
      isDay: isDay[index],
    );
  }
}

/// Soatlik ob-havo snapshot
class HourlyWeatherSnapshot extends Equatable {
  final DateTime time;
  final double temperature;
  final int relativeHumidity;
  final double apparentTemperature;
  final int precipitationProbability;
  final double precipitation;
  final int weatherCode;
  final int cloudCover;
  final double visibility;
  final double windSpeed;
  final int windDirection;
  final double uvIndex;
  final bool isDay;

  const HourlyWeatherSnapshot({
    required this.time,
    required this.temperature,
    required this.relativeHumidity,
    required this.apparentTemperature,
    required this.precipitationProbability,
    required this.precipitation,
    required this.weatherCode,
    required this.cloudCover,
    required this.visibility,
    required this.windSpeed,
    required this.windDirection,
    required this.uvIndex,
    required this.isDay,
  });

  @override
  List<Object?> get props => [
        time,
        temperature,
        relativeHumidity,
        apparentTemperature,
        precipitationProbability,
        precipitation,
        weatherCode,
        cloudCover,
        visibility,
        windSpeed,
        windDirection,
        uvIndex,
        isDay,
      ];
}

/// Kunlik ob-havo Entity
class DailyWeatherEntity extends Equatable {
  /// Sanalar ro'yxati
  final List<DateTime> time;
  
  /// WMO ob-havo kodi
  final List<int> weatherCode;
  
  /// Maksimal harorat (°C)
  final List<double> temperatureMax;
  
  /// Minimal harorat (°C)
  final List<double> temperatureMin;
  
  /// Quyosh chiqishi vaqti
  final List<DateTime> sunrise;
  
  /// Quyosh botishi vaqti
  final List<DateTime> sunset;
  
  /// Kunduz davomiyligi (sekund)
  final List<double> daylightDuration;
  
  /// Quyoshli vaqt davomiyligi (sekund)
  final List<double> sunshineDuration;
  
  /// Maksimal UV indeksi
  final List<double> uvIndexMax;
  
  /// Umumiy yog'ingarchilik (mm)
  final List<double> precipitationSum;
  
  /// Maksimal yog'ingarchilik ehtimoli (%)
  final List<int> precipitationProbabilityMax;
  
  /// Maksimal shamol tezligi (km/s)
  final List<double> windSpeedMax;
  
  /// Maksimal shamol gust (km/s)
  final List<double> windGustsMax;
  
  /// Dominant shamol yo'nalishi (°)
  final List<int> windDirectionDominant;

  const DailyWeatherEntity({
    required this.time,
    required this.weatherCode,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.sunrise,
    required this.sunset,
    required this.daylightDuration,
    required this.sunshineDuration,
    required this.uvIndexMax,
    required this.precipitationSum,
    required this.precipitationProbabilityMax,
    required this.windSpeedMax,
    required this.windGustsMax,
    required this.windDirectionDominant,
  });

  @override
  List<Object?> get props => [
        time,
        weatherCode,
        temperatureMax,
        temperatureMin,
        sunrise,
        sunset,
        daylightDuration,
        sunshineDuration,
        uvIndexMax,
        precipitationSum,
        precipitationProbabilityMax,
        windSpeedMax,
        windGustsMax,
        windDirectionDominant,
      ];

  /// Ma'lum kun uchun ob-havo olish
  DailyWeatherSnapshot? getSnapshotAt(int index) {
    if (index < 0 || index >= time.length) return null;
    
    return DailyWeatherSnapshot(
      time: time[index],
      weatherCode: weatherCode[index],
      temperatureMax: temperatureMax[index],
      temperatureMin: temperatureMin[index],
      sunrise: sunrise[index],
      sunset: sunset[index],
      daylightDuration: daylightDuration[index],
      sunshineDuration: sunshineDuration[index],
      uvIndexMax: uvIndexMax[index],
      precipitationSum: precipitationSum[index],
      precipitationProbabilityMax: precipitationProbabilityMax[index],
      windSpeedMax: windSpeedMax[index],
      windGustsMax: windGustsMax[index],
      windDirectionDominant: windDirectionDominant[index],
    );
  }
}

/// Kunlik ob-havo snapshot
class DailyWeatherSnapshot extends Equatable {
  final DateTime time;
  final int weatherCode;
  final double temperatureMax;
  final double temperatureMin;
  final DateTime sunrise;
  final DateTime sunset;
  final double daylightDuration;
  final double sunshineDuration;
  final double uvIndexMax;
  final double precipitationSum;
  final int precipitationProbabilityMax;
  final double windSpeedMax;
  final double windGustsMax;
  final int windDirectionDominant;

  const DailyWeatherSnapshot({
    required this.time,
    required this.weatherCode,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.sunrise,
    required this.sunset,
    required this.daylightDuration,
    required this.sunshineDuration,
    required this.uvIndexMax,
    required this.precipitationSum,
    required this.precipitationProbabilityMax,
    required this.windSpeedMax,
    required this.windGustsMax,
    required this.windDirectionDominant,
  });

  @override
  List<Object?> get props => [
        time,
        weatherCode,
        temperatureMax,
        temperatureMin,
        sunrise,
        sunset,
        daylightDuration,
        sunshineDuration,
        uvIndexMax,
        precipitationSum,
        precipitationProbabilityMax,
        windSpeedMax,
        windGustsMax,
        windDirectionDominant,
      ];
}
