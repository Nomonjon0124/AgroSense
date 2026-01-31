import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

/// Dala (Field) entity
class FieldEntity extends Equatable {
  final String id;
  final String name;
  final List<LatLng> coordinates;
  final double areaHectares;
  final FieldStatus status;
  final String currentStage;
  final int moisture;
  final double soilTemperature;
  final int healthPercentage;
  final String? cropType;
  final DateTime? lastUpdated;

  const FieldEntity({
    required this.id,
    required this.name,
    required this.coordinates,
    required this.areaHectares,
    required this.status,
    required this.currentStage,
    required this.moisture,
    required this.soilTemperature,
    required this.healthPercentage,
    this.cropType,
    this.lastUpdated,
  });

  /// Dalaning markazi
  LatLng get center {
    if (coordinates.isEmpty) {
      return const LatLng(0, 0);
    }

    double latSum = 0;
    double lngSum = 0;

    for (final coord in coordinates) {
      latSum += coord.latitude;
      lngSum += coord.longitude;
    }

    return LatLng(latSum / coordinates.length, lngSum / coordinates.length);
  }

  @override
  List<Object?> get props => [
    id,
    name,
    coordinates,
    areaHectares,
    status,
    currentStage,
    moisture,
    soilTemperature,
    healthPercentage,
    cropType,
    lastUpdated,
  ];
}

/// Dala holati
enum FieldStatus { good, warning, critical }

/// Demo dalalar (keyinchalik backenddan keladi)
class DemoFields {
  static List<FieldEntity> getFields(LatLng center) {
    return [
      FieldEntity(
        id: '1',
        name: 'Wheat Field A',
        coordinates: [
          LatLng(center.latitude + 0.002, center.longitude - 0.003),
          LatLng(center.latitude + 0.004, center.longitude - 0.003),
          LatLng(center.latitude + 0.004, center.longitude - 0.001),
          LatLng(center.latitude + 0.002, center.longitude - 0.001),
        ],
        areaHectares: 12.5,
        status: FieldStatus.warning,
        currentStage: 'Sowing Stage',
        moisture: 22,
        soilTemperature: 18,
        healthPercentage: 98,
        cropType: 'Wheat',
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      FieldEntity(
        id: '2',
        name: 'Corn Field B',
        coordinates: [
          LatLng(center.latitude - 0.001, center.longitude + 0.002),
          LatLng(center.latitude + 0.001, center.longitude + 0.002),
          LatLng(center.latitude + 0.001, center.longitude + 0.004),
          LatLng(center.latitude - 0.001, center.longitude + 0.004),
        ],
        areaHectares: 8.3,
        status: FieldStatus.good,
        currentStage: 'Growing Stage',
        moisture: 45,
        soilTemperature: 20,
        healthPercentage: 95,
        cropType: 'Corn',
        lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      FieldEntity(
        id: '3',
        name: 'Soybean Plot',
        coordinates: [
          LatLng(center.latitude - 0.004, center.longitude - 0.002),
          LatLng(center.latitude - 0.003, center.longitude - 0.002),
          LatLng(center.latitude - 0.003, center.longitude),
          LatLng(center.latitude - 0.004, center.longitude),
        ],
        areaHectares: 5.7,
        status: FieldStatus.good,
        currentStage: 'Preparation',
        moisture: 38,
        soilTemperature: 19,
        healthPercentage: 100,
        cropType: 'Soybean',
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ];
  }
}
