import 'package:equatable/equatable.dart';

/// Tuproq xususiyatlari Entity - Domain qatlam uchun (SoilGrids)
class SoilPropertiesEntity extends Equatable {
  /// Geografik kengligi
  final double latitude;
  
  /// Geografik uzunligi
  final double longitude;
  
  /// Tuproq qatlamlari ma'lumotlari
  final List<SoilLayerEntity> layers;

  const SoilPropertiesEntity({
    required this.latitude,
    required this.longitude,
    required this.layers,
  });

  @override
  List<Object?> get props => [latitude, longitude, layers];

  /// Birinchi qatlamni olish (0-5cm)
  SoilLayerEntity? get topLayer => layers.isNotEmpty ? layers.first : null;

  /// Yuza qatlamlarni olish (0-30cm)
  List<SoilLayerEntity> get topsoilLayers {
    return layers.where((l) => 
      l.depth == '0-5' || l.depth == '5-15' || l.depth == '15-30'
    ).toList();
  }

  /// O'rtacha gillilik
  double? get averageClayContent {
    final clayValues = layers.where((l) => l.clay != null).map((l) => l.clay!).toList();
    if (clayValues.isEmpty) return null;
    return clayValues.reduce((a, b) => a + b) / clayValues.length;
  }

  /// O'rtacha pH
  double? get averagePH {
    final phValues = layers.where((l) => l.phh2o != null).map((l) => l.phh2o!).toList();
    if (phValues.isEmpty) return null;
    return phValues.reduce((a, b) => a + b) / phValues.length;
  }
}

/// Tuproq qatlami Entity
class SoilLayerEntity extends Equatable {
  /// Qatlam chuqurligi (masalan: "0-5", "5-15")
  final String depth;
  
  /// Bulk zichlik (kg/dm³)
  final double? bdod;
  
  /// Kation almashinuv sig'imi (cmol(c)/kg)
  final double? cec;
  
  /// Yirik zarrachalar hajmi (cm³/dm³)
  final double? cfvo;
  
  /// Gil miqdori (g/kg) - keyinchalik percentga aylantiriladi
  final double? clay;
  
  /// Umumiy azot (g/kg)
  final double? nitrogen;
  
  /// pH (H2O)
  final double? phh2o;
  
  /// Qum miqdori (g/kg)
  final double? sand;
  
  /// Lyos miqdori (g/kg)
  final double? silt;
  
  /// Organik uglerod (g/kg)
  final double? soc;
  
  /// Organik uglerod zichligi (kg/m³)
  final double? ocd;
  
  /// Organik uglerod zaxirasi (kg/m²) - faqat 0-30cm uchun
  final double? ocs;
  
  /// Suv miqdori 10kPa (cm³/dm³)
  final double? wv0010;
  
  /// Suv miqdori 33kPa (cm³/dm³) - Field Capacity
  final double? wv0033;
  
  /// Suv miqdori 1500kPa (cm³/dm³) - Wilting Point
  final double? wv1500;

  const SoilLayerEntity({
    required this.depth,
    this.bdod,
    this.cec,
    this.cfvo,
    this.clay,
    this.nitrogen,
    this.phh2o,
    this.sand,
    this.silt,
    this.soc,
    this.ocd,
    this.ocs,
    this.wv0010,
    this.wv0033,
    this.wv1500,
  });

  @override
  List<Object?> get props => [
        depth,
        bdod,
        cec,
        cfvo,
        clay,
        nitrogen,
        phh2o,
        sand,
        silt,
        soc,
        ocd,
        ocs,
        wv0010,
        wv0033,
        wv1500,
      ];

  /// Gil miqdori (percent)
  double? get clayPercent => clay != null ? clay! / 10 : null;
  
  /// Qum miqdori (percent)
  double? get sandPercent => sand != null ? sand! / 10 : null;
  
  /// Lyos miqdori (percent)
  double? get siltPercent => silt != null ? silt! / 10 : null;

  /// Mavjud suv saqlash hajmi (AWC) - cm³/dm³
  double? get availableWaterCapacity {
    if (wv0033 == null || wv1500 == null) return null;
    return wv0033! - wv1500!;
  }

  /// Tuproq teksturasini aniqlash
  SoilTexture? get texture {
    if (clayPercent == null || sandPercent == null || siltPercent == null) {
      return null;
    }
    
    final c = clayPercent!;
    final s = sandPercent!;
    final si = siltPercent!;
    
    // USDA tuproq tekstura uchburchagi
    if (c >= 40) {
      if (si >= 40) return SoilTexture.siltyClayLoam;
      if (s >= 45) return SoilTexture.sandyClay;
      return SoilTexture.clay;
    } else if (s >= 85) {
      return SoilTexture.sand;
    } else if (si >= 80) {
      return SoilTexture.silt;
    } else if (s >= 70) {
      return SoilTexture.loamySand;
    } else if (c >= 27 && c < 40) {
      if (s >= 20 && s < 45) return SoilTexture.clayLoam;
      return SoilTexture.siltyClayLoam;
    } else if (c >= 7 && c < 27) {
      if (si >= 28 && si < 50) return SoilTexture.loam;
      if (si >= 50 && si < 80) return SoilTexture.siltLoam;
      return SoilTexture.sandyLoam;
    }
    return SoilTexture.loam;
  }

  /// pH holatini aniqlash
  SoilPHStatus? get phStatus {
    if (phh2o == null) return null;
    
    if (phh2o! < 4.5) return SoilPHStatus.extremelyAcidic;
    if (phh2o! < 5.0) return SoilPHStatus.veryStronglyAcidic;
    if (phh2o! < 5.5) return SoilPHStatus.stronglyAcidic;
    if (phh2o! < 6.0) return SoilPHStatus.moderatelyAcidic;
    if (phh2o! < 6.5) return SoilPHStatus.slightlyAcidic;
    if (phh2o! < 7.3) return SoilPHStatus.neutral;
    if (phh2o! < 7.8) return SoilPHStatus.slightlyAlkaline;
    if (phh2o! < 8.4) return SoilPHStatus.moderatelyAlkaline;
    if (phh2o! < 9.0) return SoilPHStatus.stronglyAlkaline;
    return SoilPHStatus.veryStronglyAlkaline;
  }

  /// Organik modda miqdori holati
  SoilOrganicMatterStatus? get organicMatterStatus {
    if (soc == null) return null;
    
    // SOC (g/kg) ni organik moddaga aylantiramiz (SOC * 1.724)
    final om = soc! * 1.724 / 10; // percent
    
    if (om < 1.0) return SoilOrganicMatterStatus.veryLow;
    if (om < 2.0) return SoilOrganicMatterStatus.low;
    if (om < 4.0) return SoilOrganicMatterStatus.medium;
    if (om < 6.0) return SoilOrganicMatterStatus.high;
    return SoilOrganicMatterStatus.veryHigh;
  }
}

/// Tuproq teksturasi
enum SoilTexture {
  sand,           // Qum
  loamySand,      // Qumli lyos
  sandyLoam,      // Lyosli qum
  loam,           // Lyos
  siltLoam,       // Lyosli sho'r
  silt,           // Sho'r
  sandyClayLoam,  // Qumli gilli lyos
  clayLoam,       // Gilli lyos
  siltyClayLoam,  // Sho'rli gilli lyos
  sandyClay,      // Qumli gil
  siltyClay,      // Sho'rli gil
  clay,           // Gil
}

extension SoilTextureExtension on SoilTexture {
  String get displayName {
    switch (this) {
      case SoilTexture.sand:
        return 'Qum';
      case SoilTexture.loamySand:
        return 'Qumli lyos';
      case SoilTexture.sandyLoam:
        return 'Lyosli qum';
      case SoilTexture.loam:
        return 'Lyos';
      case SoilTexture.siltLoam:
        return 'Lyosli sho\'r';
      case SoilTexture.silt:
        return 'Sho\'r';
      case SoilTexture.sandyClayLoam:
        return 'Qumli gilli lyos';
      case SoilTexture.clayLoam:
        return 'Gilli lyos';
      case SoilTexture.siltyClayLoam:
        return 'Sho\'rli gilli lyos';
      case SoilTexture.sandyClay:
        return 'Qumli gil';
      case SoilTexture.siltyClay:
        return 'Sho\'rli gil';
      case SoilTexture.clay:
        return 'Gil';
    }
  }

  /// Suv o'tkazuvchanligi
  String get drainageDescription {
    switch (this) {
      case SoilTexture.sand:
      case SoilTexture.loamySand:
        return 'Juda tez suv o\'tkazadi';
      case SoilTexture.sandyLoam:
        return 'Tez suv o\'tkazadi';
      case SoilTexture.loam:
      case SoilTexture.siltLoam:
        return 'O\'rtacha suv o\'tkazadi';
      case SoilTexture.silt:
      case SoilTexture.sandyClayLoam:
      case SoilTexture.clayLoam:
        return 'Sekin suv o\'tkazadi';
      case SoilTexture.siltyClayLoam:
      case SoilTexture.sandyClay:
      case SoilTexture.siltyClay:
      case SoilTexture.clay:
        return 'Juda sekin suv o\'tkazadi';
    }
  }
}

/// Tuproq pH holati
enum SoilPHStatus {
  extremelyAcidic,      // < 4.5
  veryStronglyAcidic,   // 4.5-5.0
  stronglyAcidic,       // 5.0-5.5
  moderatelyAcidic,     // 5.5-6.0
  slightlyAcidic,       // 6.0-6.5
  neutral,              // 6.5-7.3
  slightlyAlkaline,     // 7.3-7.8
  moderatelyAlkaline,   // 7.8-8.4
  stronglyAlkaline,     // 8.4-9.0
  veryStronglyAlkaline, // > 9.0
}

extension SoilPHStatusExtension on SoilPHStatus {
  String get displayName {
    switch (this) {
      case SoilPHStatus.extremelyAcidic:
        return 'Juda kuchli kislotali';
      case SoilPHStatus.veryStronglyAcidic:
        return 'Kuchli kislotali';
      case SoilPHStatus.stronglyAcidic:
        return 'O\'rtacha kislotali';
      case SoilPHStatus.moderatelyAcidic:
        return 'Yengil kislotali';
      case SoilPHStatus.slightlyAcidic:
        return 'Ozgina kislotali';
      case SoilPHStatus.neutral:
        return 'Neytral';
      case SoilPHStatus.slightlyAlkaline:
        return 'Ozgina ishqoriy';
      case SoilPHStatus.moderatelyAlkaline:
        return 'Yengil ishqoriy';
      case SoilPHStatus.stronglyAlkaline:
        return 'Kuchli ishqoriy';
      case SoilPHStatus.veryStronglyAlkaline:
        return 'Juda kuchli ishqoriy';
    }
  }

  String get recommendation {
    switch (this) {
      case SoilPHStatus.extremelyAcidic:
      case SoilPHStatus.veryStronglyAcidic:
        return 'Ohak qo\'shish tavsiya etiladi';
      case SoilPHStatus.stronglyAcidic:
      case SoilPHStatus.moderatelyAcidic:
        return 'pH ni oshirish uchun ohak qo\'shish mumkin';
      case SoilPHStatus.slightlyAcidic:
      case SoilPHStatus.neutral:
        return 'Ko\'pgina ekinlar uchun optimal pH';
      case SoilPHStatus.slightlyAlkaline:
        return 'Ba\'zi ekinlar uchun mos, boshqalari uchun pH ni kamaytirish kerak';
      case SoilPHStatus.moderatelyAlkaline:
      case SoilPHStatus.stronglyAlkaline:
        return 'Oltingugurt yoki ammoniy sulfat qo\'shish tavsiya etiladi';
      case SoilPHStatus.veryStronglyAlkaline:
        return 'Jiddiy pH muammosi, mutaxassis maslahat kerak';
    }
  }
}

/// Organik modda holati
enum SoilOrganicMatterStatus {
  veryLow,  // < 1%
  low,      // 1-2%
  medium,   // 2-4%
  high,     // 4-6%
  veryHigh, // > 6%
}

extension SoilOrganicMatterStatusExtension on SoilOrganicMatterStatus {
  String get displayName {
    switch (this) {
      case SoilOrganicMatterStatus.veryLow:
        return 'Juda kam';
      case SoilOrganicMatterStatus.low:
        return 'Kam';
      case SoilOrganicMatterStatus.medium:
        return 'O\'rtacha';
      case SoilOrganicMatterStatus.high:
        return 'Ko\'p';
      case SoilOrganicMatterStatus.veryHigh:
        return 'Juda ko\'p';
    }
  }

  String get recommendation {
    switch (this) {
      case SoilOrganicMatterStatus.veryLow:
        return 'Go\'ng va kompost qo\'shish juda zarur';
      case SoilOrganicMatterStatus.low:
        return 'Organik o\'g\'itlar qo\'shish tavsiya etiladi';
      case SoilOrganicMatterStatus.medium:
        return 'Tuproq unumdorligi o\'rtacha, saqlab turish kerak';
      case SoilOrganicMatterStatus.high:
        return 'Tuproq unumdor, organik moddalar yetarli';
      case SoilOrganicMatterStatus.veryHigh:
        return 'Tuproq juda unumdor';
    }
  }
}
