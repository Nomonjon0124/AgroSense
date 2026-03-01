import 'package:equatable/equatable.dart';

import '../../../../features/weather/domain/entities/weather_entity.dart';
import '../../../../core/services/location_service.dart';

/// Dashboard holat klassi
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

/// Boshlang'ich holat
class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

/// Ma'lumotlar yuklanmoqda
class DashboardLoading extends DashboardState {
  final DashboardData? previousData;

  const DashboardLoading({this.previousData});

  @override
  List<Object?> get props => [previousData];
}

/// Ma'lumotlar muvaffaqiyatli yuklandi
class DashboardLoaded extends DashboardState {
  final DashboardData data;

  const DashboardLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

/// Xatolik yuz berdi
class DashboardError extends DashboardState {
  final String message;
  final DashboardData? previousData;

  const DashboardError({required this.message, this.previousData});

  @override
  List<Object?> get props => [message, previousData];
}

/// Dashboard uchun yig'ilgan ma'lumotlar
class DashboardData extends Equatable {
  /// Joylashuv ma'lumotlari
  final LocationData location;

  /// Ob-havo ma'lumotlari
  final WeatherEntity weather;

  /// Oxirgi yangilanish vaqti
  final DateTime lastUpdated;

  /// Online/Offline holati
  final bool isOnline;

  /// Ma'lumot keshdan olinganmi
  final bool isFromCache;

  const DashboardData({
    required this.location,
    required this.weather,
    required this.lastUpdated,
    required this.isOnline,
    this.isFromCache = false,
  });

  /// Joriy ob-havo
  CurrentWeatherEntity? get currentWeather => weather.currentWeather;

  /// Kunlik prognoz
  DailyWeatherEntity? get dailyWeather => weather.dailyWeather;

  /// Soatlik prognoz
  HourlyWeatherEntity? get hourlyWeather => weather.hourlyWeather;

  /// Salomlashish matni (vaqtga qarab)
  String get greeting {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'greeting.morning';
    } else if (hour >= 12 && hour < 17) {
      return 'greeting.afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'greeting.evening';
    } else {
      return 'greeting.night';
    }
  }

  /// Oxirgi sinxronizatsiya vaqti formatlangan
  String get lastSyncTime {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);

    if (difference.inMinutes < 1) {
      return '0m';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      final hour = lastUpdated.hour.toString().padLeft(2, '0');
      final minute = lastUpdated.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }
  }

  DashboardData copyWith({
    LocationData? location,
    WeatherEntity? weather,
    DateTime? lastUpdated,
    bool? isOnline,
    bool? isFromCache,
  }) {
    return DashboardData(
      location: location ?? this.location,
      weather: weather ?? this.weather,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isOnline: isOnline ?? this.isOnline,
      isFromCache: isFromCache ?? this.isFromCache,
    );
  }

  @override
  List<Object?> get props => [
    location,
    weather,
    lastUpdated,
    isOnline,
    isFromCache,
  ];
}
