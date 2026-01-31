import '../../domain/entities/soil_properties_entity.dart';

/// SoilGrids API'dan keluvchi tuproq xususiyatlari javob modeli
class SoilPropertiesResponseModel {
  final String type;
  final SoilGeometryModel geometry;
  final SoilPropertiesDataModel properties;

  SoilPropertiesResponseModel({
    required this.type,
    required this.geometry,
    required this.properties,
  });

  factory SoilPropertiesResponseModel.fromJson(Map<String, dynamic> json) {
    return SoilPropertiesResponseModel(
      type: json['type'] as String? ?? 'Feature',
      geometry: SoilGeometryModel.fromJson(
        json['geometry'] as Map<String, dynamic>? ?? {},
      ),
      properties: SoilPropertiesDataModel.fromJson(
        json['properties'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'geometry': geometry.toJson(),
      'properties': properties.toJson(),
    };
  }

  /// Entity'ga aylantirish
  SoilPropertiesEntity toEntity() {
    final List<SoilLayerEntity> layers = [];
    
    // Har bir chuqurlik uchun layer yaratish
    final depths = ['0-5', '5-15', '15-30', '30-60', '60-100', '100-200'];
    
    for (final depth in depths) {
      layers.add(SoilLayerEntity(
        depth: depth,
        bdod: properties.getPropertyValue('bdod', depth),
        cec: properties.getPropertyValue('cec', depth),
        cfvo: properties.getPropertyValue('cfvo', depth),
        clay: properties.getPropertyValue('clay', depth),
        nitrogen: properties.getPropertyValue('nitrogen', depth),
        phh2o: properties.getPropertyValue('phh2o', depth),
        sand: properties.getPropertyValue('sand', depth),
        silt: properties.getPropertyValue('silt', depth),
        soc: properties.getPropertyValue('soc', depth),
        ocd: properties.getPropertyValue('ocd', depth),
        ocs: depth == '0-30' ? properties.getPropertyValue('ocs', depth) : null,
        wv0010: properties.getPropertyValue('wv0010', depth),
        wv0033: properties.getPropertyValue('wv0033', depth),
        wv1500: properties.getPropertyValue('wv1500', depth),
      ));
    }

    return SoilPropertiesEntity(
      latitude: geometry.coordinates.isNotEmpty ? geometry.coordinates[1] : 0.0,
      longitude: geometry.coordinates.isNotEmpty ? geometry.coordinates[0] : 0.0,
      layers: layers.where((l) => l.hasAnyData).toList(),
    );
  }
}

/// Geometriya modeli
class SoilGeometryModel {
  final String type;
  final List<double> coordinates;

  SoilGeometryModel({
    required this.type,
    required this.coordinates,
  });

  factory SoilGeometryModel.fromJson(Map<String, dynamic> json) {
    return SoilGeometryModel(
      type: json['type'] as String? ?? 'Point',
      coordinates: (json['coordinates'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}

/// Tuproq xususiyatlari data modeli
class SoilPropertiesDataModel {
  final Map<String, SoilPropertyLayersModel> layers;

  SoilPropertiesDataModel({
    required this.layers,
  });

  factory SoilPropertiesDataModel.fromJson(Map<String, dynamic> json) {
    final Map<String, SoilPropertyLayersModel> parsedLayers = {};
    
    // "layers" ichidagi har bir property ni parse qilish
    if (json['layers'] != null) {
      final layersJson = json['layers'] as Map<String, dynamic>;
      for (final entry in layersJson.entries) {
        parsedLayers[entry.key] = SoilPropertyLayersModel.fromJson(
          entry.value as Map<String, dynamic>,
        );
      }
    }

    return SoilPropertiesDataModel(layers: parsedLayers);
  }

  Map<String, dynamic> toJson() {
    return {
      'layers': layers.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  /// Ma'lum property va chuqurlik uchun qiymat olish
  double? getPropertyValue(String property, String depth) {
    final propertyLayers = layers[property];
    if (propertyLayers == null) return null;

    final depthData = propertyLayers.depths[depth];
    if (depthData == null) return null;

    // "mean" qiymatni qaytarish
    return depthData.values['mean']?.value;
  }
}

/// Tuproq xususiyati qatlamlari modeli
class SoilPropertyLayersModel {
  final String name;
  final String unitMeasure;
  final String mappedUnits;
  final double conversionFactor;
  final Map<String, SoilDepthDataModel> depths;

  SoilPropertyLayersModel({
    required this.name,
    required this.unitMeasure,
    required this.mappedUnits,
    required this.conversionFactor,
    required this.depths,
  });

  factory SoilPropertyLayersModel.fromJson(Map<String, dynamic> json) {
    final Map<String, SoilDepthDataModel> parsedDepths = {};
    
    if (json['depths'] != null) {
      final depthsJson = json['depths'] as Map<String, dynamic>;
      for (final entry in depthsJson.entries) {
        parsedDepths[entry.key] = SoilDepthDataModel.fromJson(
          entry.value as Map<String, dynamic>,
        );
      }
    }

    // unit_measure ni xavfsiz parse qilish
    String unitMeasure = '';
    String mappedUnits = '';
    double conversionFactor = 1.0;
    
    final unitMeasureData = json['unit_measure'];
    if (unitMeasureData != null && unitMeasureData is Map<String, dynamic>) {
      mappedUnits = unitMeasureData['mapped_units'] as String? ?? '';
      unitMeasure = mappedUnits;
      final cf = unitMeasureData['conversion_factor'];
      if (cf != null) {
        conversionFactor = (cf as num).toDouble();
      }
    }

    return SoilPropertyLayersModel(
      name: json['name'] as String? ?? '',
      unitMeasure: unitMeasure,
      mappedUnits: mappedUnits,
      conversionFactor: conversionFactor,
      depths: parsedDepths,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'unit_measure': {
        'mapped_units': mappedUnits,
        'conversion_factor': conversionFactor,
      },
      'depths': depths.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}

/// Chuqurlik ma'lumotlari modeli
class SoilDepthDataModel {
  final SoilDepthRangeModel range;
  final String label;
  final Map<String, SoilValueModel> values;

  SoilDepthDataModel({
    required this.range,
    required this.label,
    required this.values,
  });

  factory SoilDepthDataModel.fromJson(Map<String, dynamic> json) {
    final Map<String, SoilValueModel> parsedValues = {};
    
    if (json['values'] != null) {
      final valuesJson = json['values'] as Map<String, dynamic>;
      for (final entry in valuesJson.entries) {
        if (entry.value != null) {
          parsedValues[entry.key] = SoilValueModel.fromJson(
            entry.value is Map<String, dynamic>
                ? entry.value as Map<String, dynamic>
                : {'value': entry.value},
          );
        }
      }
    }

    return SoilDepthDataModel(
      range: SoilDepthRangeModel.fromJson(
        json['range'] as Map<String, dynamic>? ?? {},
      ),
      label: json['label'] as String? ?? '',
      values: parsedValues,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'range': range.toJson(),
      'label': label,
      'values': values.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}

/// Chuqurlik oralig'i modeli
class SoilDepthRangeModel {
  final int topDepth;
  final int bottomDepth;
  final String unitDepth;

  SoilDepthRangeModel({
    required this.topDepth,
    required this.bottomDepth,
    required this.unitDepth,
  });

  factory SoilDepthRangeModel.fromJson(Map<String, dynamic> json) {
    return SoilDepthRangeModel(
      topDepth: json['top_depth'] as int? ?? 0,
      bottomDepth: json['bottom_depth'] as int? ?? 0,
      unitDepth: json['unit_depth'] as String? ?? 'cm',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'top_depth': topDepth,
      'bottom_depth': bottomDepth,
      'unit_depth': unitDepth,
    };
  }
}

/// Tuproq qiymati modeli
class SoilValueModel {
  final double? value;

  SoilValueModel({
    this.value,
  });

  factory SoilValueModel.fromJson(Map<String, dynamic> json) {
    final rawValue = json['value'];
    return SoilValueModel(
      value: rawValue != null ? (rawValue as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
    };
  }
}

/// SoilLayerEntity uchun extension - hasAnyData
extension SoilLayerEntityExtension on SoilLayerEntity {
  bool get hasAnyData {
    return bdod != null ||
        cec != null ||
        cfvo != null ||
        clay != null ||
        nitrogen != null ||
        phh2o != null ||
        sand != null ||
        silt != null ||
        soc != null ||
        ocd != null ||
        ocs != null ||
        wv0010 != null ||
        wv0033 != null ||
        wv1500 != null;
  }
}
