import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../../core/services/location_service.dart';
import '../../../../core/network/network_info.dart';
import '../../../weather/domain/repositories/weather_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

/// Dashboard BLoC
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final WeatherRepository weatherRepository;
  final LocationService locationService;
  final NetworkInfo networkInfo;
  final Connectivity connectivity;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  DashboardBloc({
    required this.weatherRepository,
    required this.locationService,
    required this.networkInfo,
    required this.connectivity,
  }) : super(const DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onRefreshDashboard);
    on<UpdateLocation>(_onUpdateLocation);
    on<NetworkStatusChanged>(_onNetworkStatusChanged);

    // Tarmoq holatini kuzatish
    _connectivitySubscription = connectivity.onConnectivityChanged.listen((
      result,
    ) {
      final isOnline =
          result.isNotEmpty && !result.contains(ConnectivityResult.none);
      add(NetworkStatusChanged(isOnline: isOnline));
    });
  }

  /// Dashboard ma'lumotlarini yuklash
  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    // Oldingi ma'lumotlarni saqlash (loading paytida ko'rsatish uchun)
    DashboardData? previousData;
    if (state is DashboardLoaded) {
      previousData = (state as DashboardLoaded).data;
    } else if (state is DashboardError) {
      previousData = (state as DashboardError).previousData;
    }

    emit(DashboardLoading(previousData: previousData));

    try {
      // Tarmoq holatini tekshirish
      final isOnline = await networkInfo.isConnected;

      // Joylashuvni olish
      final location = await locationService.getCurrentLocation();

      // Ob-havo ma'lumotlarini olish
      final weatherResult = await weatherRepository.getWeather(
        latitude: location.latitude,
        longitude: location.longitude,
        forecastDays: 7,
        forceRefresh: event.forceRefresh,
      );

      weatherResult.fold(
        (failure) {
          emit(
            DashboardError(
              message: failure.message,
              previousData: previousData,
            ),
          );
        },
        (weather) {
          final data = DashboardData(
            location: location,
            weather: weather,
            lastUpdated: DateTime.now(),
            isOnline: isOnline,
            isFromCache: !isOnline,
          );
          emit(DashboardLoaded(data: data));
        },
      );
    } on LocationPermissionDeniedException {
      emit(
        DashboardError(
          message:
              'Joylashuv ruxsati kerak. Iltimos, sozlamalardan ruxsat bering.',
          previousData: previousData,
        ),
      );
    } on LocationServiceDisabledException {
      emit(
        DashboardError(
          message: 'GPS xizmati o\'chirilgan. Iltimos, GPS ni yoqing.',
          previousData: previousData,
        ),
      );
    } catch (e) {
      emit(
        DashboardError(
          message: 'Xatolik yuz berdi: ${e.toString()}',
          previousData: previousData,
        ),
      );
    }
  }

  /// Ma'lumotlarni yangilash
  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    add(const LoadDashboard(forceRefresh: true));
  }

  /// Joylashuvni yangilash
  Future<void> _onUpdateLocation(
    UpdateLocation event,
    Emitter<DashboardState> emit,
  ) async {
    add(const LoadDashboard(forceRefresh: true));
  }

  /// Tarmoq holati o'zgarganda
  Future<void> _onNetworkStatusChanged(
    NetworkStatusChanged event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentData = (state as DashboardLoaded).data;
      emit(
        DashboardLoaded(data: currentData.copyWith(isOnline: event.isOnline)),
      );

      // Agar online bo'lsa va keshdan ma'lumot bo'lsa - yangilash
      if (event.isOnline && currentData.isFromCache) {
        add(const LoadDashboard(forceRefresh: true));
      }
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
