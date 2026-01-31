import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/services/location_service.dart';
import '../../../../core/network/network_info.dart';
import '../../../map/domain/entities/field_entity.dart';
import 'map_event.dart';
import 'map_state.dart';

/// Map BLoC
class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationService locationService;
  final NetworkInfo networkInfo;
  final Connectivity connectivity;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  /// Oxirgi ma'lum joylashuv
  LatLng _lastKnownCenter = const LatLng(41.2995, 69.2401); // Toshkent default

  MapBloc({
    required this.locationService,
    required this.networkInfo,
    required this.connectivity,
  }) : super(const MapInitial()) {
    on<LoadMap>(_onLoadMap);
    on<RefreshMap>(_onRefreshMap);
    on<SelectField>(_onSelectField);
    on<DeselectField>(_onDeselectField);
    on<GoToCurrentLocation>(_onGoToCurrentLocation);
    on<CacheMapTiles>(_onCacheMapTiles);
    on<MapNetworkStatusChanged>(_onNetworkStatusChanged);

    // Tarmoq holatini kuzatish
    _connectivitySubscription = connectivity.onConnectivityChanged.listen((
      result,
    ) {
      final isOnline =
          result.isNotEmpty && !result.contains(ConnectivityResult.none);
      add(MapNetworkStatusChanged(isOnline: isOnline));
    });
  }

  /// Xaritani yuklash (fonda, progress bilan)
  Future<void> _onLoadMap(LoadMap event, Emitter<MapState> emit) async {
    // 1. Darhol xarita ko'rsatish + Loading overlay (0%)
    emit(
      MapDataLoading(
        mapCenter: _lastKnownCenter,
        progress: 0,
        loadingMessage: 'Xarita tayyorlanmoqda...',
      ),
    );

    try {
      // 2. Tarmoq holatini tekshirish (10%)
      await Future.delayed(const Duration(milliseconds: 200));
      emit(
        MapDataLoading(
          mapCenter: _lastKnownCenter,
          progress: 10,
          loadingMessage: 'Tarmoq tekshirilmoqda...',
        ),
      );

      final isOnline = await networkInfo.isConnected;

      // 3. Joylashuvni olish (30%)
      emit(
        MapDataLoading(
          mapCenter: _lastKnownCenter,
          progress: 30,
          loadingMessage: 'Joylashuv aniqlanmoqda...',
        ),
      );

      final location = await locationService.getCurrentLocation();
      _lastKnownCenter = LatLng(location.latitude, location.longitude);

      // 4. Xarita markazini yangilash (50%)
      emit(
        MapDataLoading(
          mapCenter: _lastKnownCenter,
          progress: 50,
          loadingMessage: 'Xarita yuklanmoqda...',
        ),
      );

      await Future.delayed(const Duration(milliseconds: 300));

      // 5. Dalalarni yuklash (70%)
      emit(
        MapDataLoading(
          mapCenter: _lastKnownCenter,
          progress: 70,
          loadingMessage: 'Dala ma\'lumotlari yuklanmoqda...',
        ),
      );

      final fields = DemoFields.getFields(_lastKnownCenter);

      await Future.delayed(const Duration(milliseconds: 200));

      // 6. Ob-havo ma'lumotlarini yuklash (90%)
      emit(
        MapDataLoading(
          mapCenter: _lastKnownCenter,
          progress: 90,
          loadingMessage: 'Ob-havo ma\'lumotlari yuklanmoqda...',
        ),
      );

      await Future.delayed(const Duration(milliseconds: 200));

      // 7. Tayyor! (100%)
      emit(
        MapDataLoading(
          mapCenter: _lastKnownCenter,
          progress: 100,
          loadingMessage: 'Tayyor!',
        ),
      );

      await Future.delayed(const Duration(milliseconds: 300));

      // Final state
      emit(
        MapLoaded(
          data: MapData(
            location: location,
            fields: fields,
            isMapCached: true,
            lastCachedTime: DateTime.now(),
            isOnline: isOnline,
          ),
        ),
      );
    } on LocationPermissionDeniedException {
      emit(
        MapError(
          message:
              'Joylashuv ruxsati kerak. Iltimos, sozlamalardan ruxsat bering.',
          mapCenter: _lastKnownCenter,
        ),
      );
    } on LocationServiceDisabledException {
      emit(
        MapError(
          message: 'GPS xizmati o\'chirilgan. Iltimos, GPS ni yoqing.',
          mapCenter: _lastKnownCenter,
        ),
      );
    } catch (e) {
      emit(
        MapError(
          message: 'Xatolik yuz berdi: ${e.toString()}',
          mapCenter: _lastKnownCenter,
        ),
      );
    }
  }

  /// Xaritani yangilash
  Future<void> _onRefreshMap(RefreshMap event, Emitter<MapState> emit) async {
    add(const LoadMap());
  }

  /// Dala tanlash
  void _onSelectField(SelectField event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      final currentData = (state as MapLoaded).data;
      emit(MapLoaded(data: currentData.copyWith(selectedField: event.field)));
    }
  }

  /// Dala tanlovini bekor qilish
  void _onDeselectField(DeselectField event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      final currentData = (state as MapLoaded).data;
      emit(MapLoaded(data: currentData.copyWith(clearSelectedField: true)));
    }
  }

  /// Joriy joylashuvga o'tish
  Future<void> _onGoToCurrentLocation(
    GoToCurrentLocation event,
    Emitter<MapState> emit,
  ) async {
    if (state is MapLoaded) {
      try {
        final location = await locationService.getCurrentLocation();
        _lastKnownCenter = LatLng(location.latitude, location.longitude);
        final currentData = (state as MapLoaded).data;
        emit(MapLoaded(data: currentData.copyWith(location: location)));
      } catch (e) {
        // Xatolikni e'tiborsiz qoldirish
      }
    }
  }

  /// Xaritani keshlash
  Future<void> _onCacheMapTiles(
    CacheMapTiles event,
    Emitter<MapState> emit,
  ) async {
    if (state is MapLoaded) {
      final currentData = (state as MapLoaded).data;
      emit(
        MapLoaded(
          data: currentData.copyWith(
            isMapCached: true,
            lastCachedTime: DateTime.now(),
          ),
        ),
      );
    }
  }

  /// Tarmoq holati o'zgarganda
  void _onNetworkStatusChanged(
    MapNetworkStatusChanged event,
    Emitter<MapState> emit,
  ) {
    if (state is MapLoaded) {
      final currentData = (state as MapLoaded).data;
      emit(MapLoaded(data: currentData.copyWith(isOnline: event.isOnline)));
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
