import 'package:equatable/equatable.dart';

/// Tuproq namligi Entity - Domain qatlam uchun
class SoilMoistureEntity extends Equatable {
  /// Geografik kengligi
  final double latitude;
  
  /// Geografik uzunligi
  final double longitude;
  
  /// Balandlik (metr)
  final double elevation;
  
  /// Vaqt zonasi
  final String timezone;
  
  /// Soatlik tuproq namligi ma'lumotlari
  final HourlySoilMoistureEntity? hourlySoilMoisture;

  const SoilMoistureEntity({
    required this.latitude,
    required this.longitude,
    required this.elevation,
    required this.timezone,
    this.hourlySoilMoisture,
  });

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        elevation,
        timezone,
        hourlySoilMoisture,
      ];
}

/// Soatlik tuproq namligi Entity
class HourlySoilMoistureEntity extends Equatable {
  /// Vaqtlar ro'yxati
  final List<DateTime> time;
  
  /// Tuproq harorati 0cm da (°C)
  final List<double> soilTemperature0cm;
  
  /// Tuproq harorati 6cm da (°C)
  final List<double> soilTemperature6cm;
  
  /// Tuproq harorati 18cm da (°C)
  final List<double> soilTemperature18cm;
  
  /// Tuproq harorati 54cm da (°C)
  final List<double> soilTemperature54cm;
  
  /// Tuproq namligi 0-1cm (m³/m³)
  final List<double> soilMoisture0to1cm;
  
  /// Tuproq namligi 1-3cm (m³/m³)
  final List<double> soilMoisture1to3cm;
  
  /// Tuproq namligi 3-9cm (m³/m³)
  final List<double> soilMoisture3to9cm;
  
  /// Tuproq namligi 9-27cm (m³/m³)
  final List<double> soilMoisture9to27cm;
  
  /// Tuproq namligi 27-81cm (m³/m³)
  final List<double> soilMoisture27to81cm;

  const HourlySoilMoistureEntity({
    required this.time,
    required this.soilTemperature0cm,
    required this.soilTemperature6cm,
    required this.soilTemperature18cm,
    required this.soilTemperature54cm,
    required this.soilMoisture0to1cm,
    required this.soilMoisture1to3cm,
    required this.soilMoisture3to9cm,
    required this.soilMoisture9to27cm,
    required this.soilMoisture27to81cm,
  });

  @override
  List<Object?> get props => [
        time,
        soilTemperature0cm,
        soilTemperature6cm,
        soilTemperature18cm,
        soilTemperature54cm,
        soilMoisture0to1cm,
        soilMoisture1to3cm,
        soilMoisture3to9cm,
        soilMoisture9to27cm,
        soilMoisture27to81cm,
      ];

  /// Ma'lum soat uchun tuproq namligi olish
  SoilMoistureSnapshot? getSnapshotAt(int index) {
    if (index < 0 || index >= time.length) return null;
    
    return SoilMoistureSnapshot(
      time: time[index],
      soilTemperature0cm: soilTemperature0cm[index],
      soilTemperature6cm: soilTemperature6cm[index],
      soilTemperature18cm: soilTemperature18cm[index],
      soilTemperature54cm: soilTemperature54cm[index],
      soilMoisture0to1cm: soilMoisture0to1cm[index],
      soilMoisture1to3cm: soilMoisture1to3cm[index],
      soilMoisture3to9cm: soilMoisture3to9cm[index],
      soilMoisture9to27cm: soilMoisture9to27cm[index],
      soilMoisture27to81cm: soilMoisture27to81cm[index],
    );
  }

  /// Joriy soat uchun o'rtacha tuproq namligi
  double getAverageMoistureAt(int index) {
    if (index < 0 || index >= time.length) return 0.0;
    
    return (soilMoisture0to1cm[index] +
            soilMoisture1to3cm[index] +
            soilMoisture3to9cm[index] +
            soilMoisture9to27cm[index] +
            soilMoisture27to81cm[index]) / 5;
  }

  /// Yuzaki qatlam namligi (0-9cm)
  double getTopsoilMoistureAt(int index) {
    if (index < 0 || index >= time.length) return 0.0;
    
    return (soilMoisture0to1cm[index] +
            soilMoisture1to3cm[index] +
            soilMoisture3to9cm[index]) / 3;
  }

  /// Chuqur qatlam namligi (9-81cm)
  double getSubsoilMoistureAt(int index) {
    if (index < 0 || index >= time.length) return 0.0;
    
    return (soilMoisture9to27cm[index] +
            soilMoisture27to81cm[index]) / 2;
  }
}

/// Tuproq namligi snapshot
class SoilMoistureSnapshot extends Equatable {
  final DateTime time;
  final double soilTemperature0cm;
  final double soilTemperature6cm;
  final double soilTemperature18cm;
  final double soilTemperature54cm;
  final double soilMoisture0to1cm;
  final double soilMoisture1to3cm;
  final double soilMoisture3to9cm;
  final double soilMoisture9to27cm;
  final double soilMoisture27to81cm;

  const SoilMoistureSnapshot({
    required this.time,
    required this.soilTemperature0cm,
    required this.soilTemperature6cm,
    required this.soilTemperature18cm,
    required this.soilTemperature54cm,
    required this.soilMoisture0to1cm,
    required this.soilMoisture1to3cm,
    required this.soilMoisture3to9cm,
    required this.soilMoisture9to27cm,
    required this.soilMoisture27to81cm,
  });

  @override
  List<Object?> get props => [
        time,
        soilTemperature0cm,
        soilTemperature6cm,
        soilTemperature18cm,
        soilTemperature54cm,
        soilMoisture0to1cm,
        soilMoisture1to3cm,
        soilMoisture3to9cm,
        soilMoisture9to27cm,
        soilMoisture27to81cm,
      ];

  /// O'rtacha tuproq harorati
  double get averageSoilTemperature {
    return (soilTemperature0cm +
            soilTemperature6cm +
            soilTemperature18cm +
            soilTemperature54cm) / 4;
  }

  /// O'rtacha tuproq namligi
  double get averageSoilMoisture {
    return (soilMoisture0to1cm +
            soilMoisture1to3cm +
            soilMoisture3to9cm +
            soilMoisture9to27cm +
            soilMoisture27to81cm) / 5;
  }

  /// Namlik holatini aniqlash
  SoilMoistureStatus get moistureStatus {
    final avg = averageSoilMoisture;
    if (avg < 0.1) return SoilMoistureStatus.veryDry;
    if (avg < 0.2) return SoilMoistureStatus.dry;
    if (avg < 0.3) return SoilMoistureStatus.optimal;
    if (avg < 0.4) return SoilMoistureStatus.wet;
    return SoilMoistureStatus.veryWet;
  }
}

/// Tuproq namligi holati
enum SoilMoistureStatus {
  veryDry,
  dry,
  optimal,
  wet,
  veryWet,
}

extension SoilMoistureStatusExtension on SoilMoistureStatus {
  String get displayName {
    switch (this) {
      case SoilMoistureStatus.veryDry:
        return 'Juda quruq';
      case SoilMoistureStatus.dry:
        return 'Quruq';
      case SoilMoistureStatus.optimal:
        return 'Optimal';
      case SoilMoistureStatus.wet:
        return 'Nam';
      case SoilMoistureStatus.veryWet:
        return 'Juda nam';
    }
  }

  String get recommendation {
    switch (this) {
      case SoilMoistureStatus.veryDry:
        return 'Sug\'orish juda zarur! Tuproq juda quruq.';
      case SoilMoistureStatus.dry:
        return 'Sug\'orish tavsiya etiladi.';
      case SoilMoistureStatus.optimal:
        return 'Tuproq namligi optimal holatda.';
      case SoilMoistureStatus.wet:
        return 'Tuproq yetarlicha nam, sug\'orish kerak emas.';
      case SoilMoistureStatus.veryWet:
        return 'Tuproq juda nam, suv siqib chiqarish kerak bo\'lishi mumkin.';
    }
  }
}
