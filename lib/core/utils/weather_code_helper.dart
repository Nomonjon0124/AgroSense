import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// WMO ob-havo kodlari uchun helper
class WeatherCodeHelper {
  WeatherCodeHelper._();

  /// WMO kodini ob-havo holatiga o'girish
  static String getCondition(int code) {
    switch (code) {
      case 0:
        return 'Clear sky';
      case 1:
        return 'Mainly clear';
      case 2:
        return 'Partly cloudy';
      case 3:
        return 'Overcast';
      case 45:
      case 48:
        return 'Foggy';
      case 51:
      case 53:
      case 55:
        return 'Drizzle';
      case 56:
      case 57:
        return 'Freezing drizzle';
      case 61:
      case 63:
      case 65:
        return 'Rainy';
      case 66:
      case 67:
        return 'Freezing rain';
      case 71:
      case 73:
      case 75:
        return 'Snowy';
      case 77:
        return 'Snow grains';
      case 80:
      case 81:
      case 82:
        return 'Rain showers';
      case 85:
      case 86:
        return 'Snow showers';
      case 95:
        return 'Thunderstorm';
      case 96:
      case 99:
        return 'Thunderstorm with hail';
      default:
        return 'Unknown';
    }
  }

  /// WMO kodini qisqartilgan holatga o'girish
  static String getShortCondition(int code) {
    switch (code) {
      case 0:
      case 1:
        return 'Sunny';
      case 2:
        return 'Partly Cloudy';
      case 3:
        return 'Cloudy';
      case 45:
      case 48:
        return 'Foggy';
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        return 'Drizzle';
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
        return 'Rainy';
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return 'Snowy';
      case 95:
      case 96:
      case 99:
        return 'Stormy';
      default:
        return 'Unknown';
    }
  }

  /// WMO kodiga mos ikonka
  static IconData getIcon(int code, {bool isDay = true}) {
    switch (code) {
      case 0:
        return isDay ? Icons.wb_sunny : Icons.nightlight_round;
      case 1:
        return isDay ? Icons.wb_sunny : Icons.nightlight_round;
      case 2:
        return isDay ? Icons.wb_cloudy : Icons.nights_stay;
      case 3:
        return Icons.cloud;
      case 45:
      case 48:
        return Icons.foggy;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        return Icons.grain;
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
        return Icons.water_drop;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return Icons.ac_unit;
      case 95:
      case 96:
      case 99:
        return Icons.thunderstorm;
      default:
        return Icons.help_outline;
    }
  }

  /// WMO kodiga mos rang
  static Color getColor(int code) {
    switch (code) {
      case 0:
      case 1:
        return AppColors.sunny;
      case 2:
      case 3:
        return AppColors.cloudy;
      case 45:
      case 48:
        return const Color(0xFF90A4AE);
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
        return AppColors.rainy;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return const Color(0xFF90CAF9);
      case 95:
      case 96:
      case 99:
        return AppColors.stormy;
      default:
        return Colors.grey;
    }
  }

  /// Kun nomini olish
  static String getDayName(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate == today) {
      return 'Today';
    }

    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[date.weekday - 1];
  }
}
