import 'package:equatable/equatable.dart';

import '../../../map/domain/entities/field_entity.dart';

/// Map eventlari
abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

/// Xaritani yuklash
class LoadMap extends MapEvent {
  const LoadMap();
}

/// Xaritani yangilash
class RefreshMap extends MapEvent {
  const RefreshMap();
}

/// Dala tanlash
class SelectField extends MapEvent {
  final FieldEntity field;

  const SelectField({required this.field});

  @override
  List<Object?> get props => [field];
}

/// Dala tanlovini bekor qilish
class DeselectField extends MapEvent {
  const DeselectField();
}

/// Joriy joylashuvga o'tish
class GoToCurrentLocation extends MapEvent {
  const GoToCurrentLocation();
}

/// Xaritani keshlash
class CacheMapTiles extends MapEvent {
  const CacheMapTiles();
}

/// Tarmoq holati o'zgardi
class MapNetworkStatusChanged extends MapEvent {
  final bool isOnline;

  const MapNetworkStatusChanged({required this.isOnline});

  @override
  List<Object?> get props => [isOnline];
}
