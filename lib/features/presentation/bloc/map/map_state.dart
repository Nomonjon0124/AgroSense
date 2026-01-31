import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/services/location_service.dart';
import '../../../map/domain/entities/field_entity.dart';

/// Map holat klassi
abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

/// Boshlang'ich holat (xarita ko'rsatiladi, ma'lumotlar yuklanadi)
class MapInitial extends MapState {
  /// Default joylashuv (Toshkent)
  final LatLng defaultCenter;

  const MapInitial({this.defaultCenter = const LatLng(41.2995, 69.2401)});

  @override
  List<Object?> get props => [defaultCenter];
}

/// Ma'lumotlar yuklanmoqda (xarita ko'rsatilgan, overlay bilan)
class MapDataLoading extends MapState {
  /// Xarita markazi (oxirgi ma'lum yoki default)
  final LatLng mapCenter;

  /// Yuklash foizi (0-100)
  final int progress;

  /// Hozirgi qadim tavsifi
  final String loadingMessage;

  const MapDataLoading({
    required this.mapCenter,
    required this.progress,
    required this.loadingMessage,
  });

  @override
  List<Object?> get props => [mapCenter, progress, loadingMessage];
}

/// Ma'lumotlar muvaffaqiyatli yuklandi
class MapLoaded extends MapState {
  final MapData data;

  const MapLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

/// Xatolik yuz berdi
class MapError extends MapState {
  final String message;

  /// Xarita hali ham ko'rsatilishi kerak
  final LatLng? mapCenter;

  const MapError({required this.message, this.mapCenter});

  @override
  List<Object?> get props => [message, mapCenter];
}

/// Map uchun yig'ilgan ma'lumotlar
class MapData extends Equatable {
  /// Joriy joylashuv
  final LocationData location;

  /// Dalalar ro'yxati
  final List<FieldEntity> fields;

  /// Tanlangan dala
  final FieldEntity? selectedField;

  /// Xarita keshi mavjudligi
  final bool isMapCached;

  /// Oxirgi kesh vaqti
  final DateTime? lastCachedTime;

  /// Online holati
  final bool isOnline;

  const MapData({
    required this.location,
    required this.fields,
    this.selectedField,
    this.isMapCached = false,
    this.lastCachedTime,
    required this.isOnline,
  });

  /// Kesh vaqti formatlangan
  String get cachedTimeAgo {
    if (lastCachedTime == null) return 'Never';

    final difference = DateTime.now().difference(lastCachedTime!);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  /// Xarita markazi
  LatLng get mapCenter => LatLng(location.latitude, location.longitude);

  MapData copyWith({
    LocationData? location,
    List<FieldEntity>? fields,
    FieldEntity? selectedField,
    bool? clearSelectedField,
    bool? isMapCached,
    DateTime? lastCachedTime,
    bool? isOnline,
  }) {
    return MapData(
      location: location ?? this.location,
      fields: fields ?? this.fields,
      selectedField:
          clearSelectedField == true
              ? null
              : (selectedField ?? this.selectedField),
      isMapCached: isMapCached ?? this.isMapCached,
      lastCachedTime: lastCachedTime ?? this.lastCachedTime,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  @override
  List<Object?> get props => [
    location,
    fields,
    selectedField,
    isMapCached,
    lastCachedTime,
    isOnline,
  ];
}
