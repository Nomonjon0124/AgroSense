part of '../map_part.dart';

mixin MapMixin on State<MapView>{
  final MapController _mapController = MapController();
  bool _isMapReady = false;
  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
  Widget _buildMap(BuildContext context, MapState state) {
    // Xarita markazi aniqlash
    LatLng mapCenter;
    List<FieldEntity> fields = [];
    FieldEntity? selectedField;

    if (state is MapInitial) {
      mapCenter = state.defaultCenter;
    } else if (state is MapDataLoading) {
      mapCenter = state.mapCenter;
    } else if (state is MapLoaded) {
      mapCenter = state.data.mapCenter;
      fields = state.data.fields;
      selectedField = state.data.selectedField;
    } else if (state is MapError) {
      mapCenter = state.mapCenter ?? const LatLng(41.2995, 69.2401);
    } else {
      mapCenter = const LatLng(41.2995, 69.2401);
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: mapCenter,
        initialZoom: 15,
        minZoom: 5,
        maxZoom: 18,
        onMapReady: () {
          setState(() => _isMapReady = true);
        },
        onTap: (_, __) {
          if (state is MapLoaded) {
            context.read<MapBloc>().add(const DeselectField());
          }
        },
      ),
      children: [
        /// Tile Layer
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.agro_sense',
          tileProvider: NetworkTileProvider(),
        ),

        /// Dalalar uchun Polygon Layer
        if (fields.isNotEmpty)
          PolygonLayer(
            polygons:
            fields.map((field) {
              final isSelected = selectedField?.id == field.id;
              return Polygon(
                points: field.coordinates,
                color: _getFieldColor(field.status, isSelected),
                borderColor: _getFieldBorderColor(field.status, isSelected),
                borderStrokeWidth: isSelected ? 3 : 2,
              );
            }).toList(),
          ),

        /// Dala markerlar
        if (fields.isNotEmpty)
          MarkerLayer(
            markers:
            fields.map((field) {
              return Marker(
                point: field.center,
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () {
                    context.read<MapBloc>().add(SelectField(field: field));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(26),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _getFieldIcon(field.cropType),
                      color: _getFieldBorderColor(field.status, false),
                      size: 24,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

        /// User Location Marker (ko'k nuqta)
        if (state is MapLoaded || state is MapDataLoading)
          MarkerLayer(
            markers: [
              Marker(
                point: mapCenter,
                width: 30,
                height: 30,
                child: const UserLocationMarker(),
              ),
            ],
          ),
      ],
    );
  }

  Color _getFieldColor(FieldStatus status, bool isSelected) {
    switch (status) {
      case FieldStatus.good:
        return AppColors.success.withAlpha(isSelected ? 77 : 51);
      case FieldStatus.warning:
        return AppColors.warning.withAlpha(isSelected ? 77 : 51);
      case FieldStatus.critical:
        return AppColors.error.withAlpha(isSelected ? 77 : 51);
    }
  }

  Color _getFieldBorderColor(FieldStatus status, bool isSelected) {
    switch (status) {
      case FieldStatus.good:
        return isSelected ? AppColors.primaryDark : AppColors.success;
      case FieldStatus.warning:
        return AppColors.warning;
      case FieldStatus.critical:
        return AppColors.error;
    }
  }

  IconData _getFieldIcon(String? cropType) {
    switch (cropType?.toLowerCase()) {
      case 'wheat':
        return Icons.grass;
      case 'corn':
        return Icons.eco;
      case 'soybean':
        return Icons.spa;
      default:
        return Icons.agriculture;
    }
  }
}