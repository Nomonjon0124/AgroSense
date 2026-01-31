/// Open-Meteo API konstantlari
/// Ob-havo va tuproq namligi ma'lumotlari uchun
class OpenMeteoConstants {
  OpenMeteoConstants._();

  // ================== BASE URLs ==================
  
  /// Asosiy API URL
  static const String baseUrl = 'https://api.open-meteo.com/v1';
  
  /// Forecast endpoint
  static const String forecastEndpoint = '/forecast';

  // ================== TIMEOUTS ==================
  
  static const int connectTimeout = 30;
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;

  // ================== QUERY PARAMETERS ==================
  
  /// Majburiy parametrlar
  static const String latitudeParam = 'latitude';
  static const String longitudeParam = 'longitude';
  
  /// Vaqt parametrlari
  static const String timezoneParam = 'timezone';
  static const String pastDaysParam = 'past_days';
  static const String forecastDaysParam = 'forecast_days';
  static const String startDateParam = 'start_date';
  static const String endDateParam = 'end_date';
  
  /// Ma'lumot formati
  static const String hourlyParam = 'hourly';
  static const String dailyParam = 'daily';
  static const String currentParam = 'current';
  static const String minutely15Param = 'minutely_15';

  // ================== OB-HAVO O'ZGARUVCHILARI ==================
  
  /// Joriy ob-havo parametrlari
  static const List<String> currentWeatherVariables = [
    'temperature_2m',
    'relative_humidity_2m',
    'apparent_temperature',
    'is_day',
    'precipitation',
    'rain',
    'showers',
    'snowfall',
    'weather_code',
    'cloud_cover',
    'pressure_msl',
    'surface_pressure',
    'wind_speed_10m',
    'wind_direction_10m',
    'wind_gusts_10m',
  ];

  /// Soatlik ob-havo parametrlari
  static const List<String> hourlyWeatherVariables = [
    'temperature_2m',
    'relative_humidity_2m',
    'dew_point_2m',
    'apparent_temperature',
    'precipitation_probability',
    'precipitation',
    'rain',
    'showers',
    'snowfall',
    'snow_depth',
    'weather_code',
    'pressure_msl',
    'surface_pressure',
    'cloud_cover',
    'cloud_cover_low',
    'cloud_cover_mid',
    'cloud_cover_high',
    'visibility',
    'evapotranspiration',
    'et0_fao_evapotranspiration',
    'vapour_pressure_deficit',
    'wind_speed_10m',
    'wind_speed_80m',
    'wind_speed_120m',
    'wind_speed_180m',
    'wind_direction_10m',
    'wind_direction_80m',
    'wind_direction_120m',
    'wind_direction_180m',
    'wind_gusts_10m',
    'temperature_80m',
    'temperature_120m',
    'temperature_180m',
    'uv_index',
    'uv_index_clear_sky',
    'is_day',
    'sunshine_duration',
  ];

  /// Kunlik ob-havo parametrlari
  static const List<String> dailyWeatherVariables = [
    'weather_code',
    'temperature_2m_max',
    'temperature_2m_min',
    'apparent_temperature_max',
    'apparent_temperature_min',
    'sunrise',
    'sunset',
    'daylight_duration',
    'sunshine_duration',
    'uv_index_max',
    'uv_index_clear_sky_max',
    'precipitation_sum',
    'rain_sum',
    'showers_sum',
    'snowfall_sum',
    'precipitation_hours',
    'precipitation_probability_max',
    'wind_speed_10m_max',
    'wind_gusts_10m_max',
    'wind_direction_10m_dominant',
    'shortwave_radiation_sum',
    'et0_fao_evapotranspiration',
  ];

  // ================== TUPROQ NAMLIGI O'ZGARUVCHILARI ==================
  
  /// Soatlik tuproq namligi parametrlari (m³/m³)
  static const List<String> hourlySoilMoistureVariables = [
    'soil_temperature_0cm',
    'soil_temperature_6cm',
    'soil_temperature_18cm',
    'soil_temperature_54cm',
    'soil_moisture_0_to_1cm',
    'soil_moisture_1_to_3cm',
    'soil_moisture_3_to_9cm',
    'soil_moisture_9_to_27cm',
    'soil_moisture_27_to_81cm',
  ];

  // ================== SOZLAMALAR ==================
  
  /// Harorat birligi
  static const String temperatureUnitCelsius = 'celsius';
  static const String temperatureUnitFahrenheit = 'fahrenheit';
  
  /// Shamol tezligi birligi
  static const String windSpeedUnitKmh = 'kmh';
  static const String windSpeedUnitMs = 'ms';
  static const String windSpeedUnitMph = 'mph';
  static const String windSpeedUnitKn = 'kn';
  
  /// Yog'ingarchilik birligi
  static const String precipitationUnitMm = 'mm';
  static const String precipitationUnitInch = 'inch';

  // ================== WMO OB-HAVO KODLARI ==================
  
  /// WMO Weather interpretation codes
  static const Map<int, String> weatherCodes = {
    0: 'Ochiq osmon',
    1: 'Asosan ochiq',
    2: 'Qisman bulutli',
    3: 'Bulutli',
    45: 'Tuman',
    48: 'Muzlagan tuman',
    51: 'Yengil shudring',
    53: "O'rtacha shudring",
    55: 'Kuchli shudring',
    56: 'Yengil muzlagan shudring',
    57: 'Kuchli muzlagan shudring',
    61: "Yengil yomg'ir",
    63: "O'rtacha yomg'ir",
    65: "Kuchli yomg'ir",
    66: "Yengil muzlagan yomg'ir",
    67: "Kuchli muzlagan yomg'ir",
    71: 'Yengil qor',
    73: "O'rtacha qor",
    75: 'Kuchli qor',
    77: 'Qor donalari',
    80: 'Yengil jala',
    81: "O'rtacha jala",
    82: 'Kuchli jala',
    85: "Yengil qorli jala",
    86: "Kuchli qorli jala",
    95: "Mo'tadil momaqaldiroq",
    96: "Do'l bilan momaqaldiroq",
    99: "Kuchli do'l bilan momaqaldiroq",
  };

  // ================== HELPER METHODS ==================
  
  /// Ob-havo kodi bo'yicha tavsif olish
  static String getWeatherDescription(int code) {
    return weatherCodes[code] ?? "Noma'lum";
  }

  /// Ob-havo kodi bo'yicha icon nomi olish
  static String getWeatherIcon(int code, {bool isDay = true}) {
    switch (code) {
      case 0:
        return isDay ? 'sunny' : 'clear_night';
      case 1:
      case 2:
        return isDay ? 'partly_cloudy' : 'partly_cloudy_night';
      case 3:
        return 'cloudy';
      case 45:
      case 48:
        return 'fog';
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        return 'drizzle';
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
        return 'rainy';
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return 'snowy';
      case 80:
      case 81:
      case 82:
        return 'showers';
      case 95:
      case 96:
      case 99:
        return 'thunderstorm';
      default:
        return 'unknown';
    }
  }
}
