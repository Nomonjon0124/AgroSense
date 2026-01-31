import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Joylashuv ma'lumotlari
class LocationData {
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final String? district;
  final String? country;
  final DateTime timestamp;

  const LocationData({
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    this.district,
    this.country,
    required this.timestamp,
  });

  /// Formatlangan manzil
  String get formattedAddress {
    if (city != null && district != null) {
      return '$city, $district';
    } else if (city != null) {
      return city!;
    } else if (address != null) {
      return address!;
    }
    return 'Lat: ${latitude.toStringAsFixed(4)}, Lon: ${longitude.toStringAsFixed(4)}';
  }

  /// Qisqa manzil
  String get shortAddress {
    if (district != null) {
      return district!;
    } else if (city != null) {
      return city!;
    }
    return formattedAddress;
  }

  LocationData copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? city,
    String? district,
    String? country,
    DateTime? timestamp,
  }) {
    return LocationData(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      district: district ?? this.district,
      country: country ?? this.country,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() =>
      'LocationData(lat: $latitude, lon: $longitude, city: $city, district: $district)';
}

/// Joylashuv xizmati interfeysi
abstract class LocationService {
  /// Joriy joylashuvni olish
  Future<LocationData> getCurrentLocation();

  /// Joylashuv ruxsatini tekshirish
  Future<bool> checkPermission();

  /// Joylashuv ruxsatini so'rash
  Future<bool> requestPermission();

  /// GPS yoqilganligini tekshirish
  Future<bool> isLocationServiceEnabled();

  /// Koordinatalardan manzil olish (Reverse Geocoding)
  Future<String?> getAddressFromCoordinates(double latitude, double longitude);
}

/// Joylashuv xizmati implementatsiyasi
class LocationServiceImpl implements LocationService {
  // Keshlanagan joylashuv
  LocationData? _cachedLocation;
  DateTime? _lastFetchTime;

  // Kesh muddati (5 daqiqa)
  static const Duration _cacheDuration = Duration(minutes: 5);

  @override
  Future<LocationData> getCurrentLocation() async {
    // Kesh tekshirish
    if (_cachedLocation != null && _lastFetchTime != null) {
      final difference = DateTime.now().difference(_lastFetchTime!);
      if (difference < _cacheDuration) {
        return _cachedLocation!;
      }
    }

    // Ruxsatni tekshirish
    final hasPermission = await checkPermission();
    if (!hasPermission) {
      final granted = await requestPermission();
      if (!granted) {
        throw LocationPermissionDeniedException();
      }
    }

    // GPS yoqilganligini tekshirish
    final serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceDisabledException();
    }

    try {
      // Joylashuvni olish
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      // Manzilni olish (reverse geocoding)
      String? address;
      String? city;
      String? district;
      String? country;

      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          address = _formatPlacemark(place);
          city = place.locality ?? place.administrativeArea;
          district = place.subLocality ?? place.subAdministrativeArea;
          country = place.country;
        }
      } catch (e) {
        // Geocoding xatoligi - koordinatalarni qaytarish
        // ignore geocoding errors
      }

      _cachedLocation = LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
        city: city,
        district: district,
        country: country,
        timestamp: DateTime.now(),
      );
      _lastFetchTime = DateTime.now();

      return _cachedLocation!;
    } catch (e) {
      // Agar keshda ma'lumot bo'lsa, uni qaytarish
      if (_cachedLocation != null) {
        return _cachedLocation!;
      }
      rethrow;
    }
  }

  @override
  Future<bool> checkPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  @override
  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  @override
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<String?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        return _formatPlacemark(placemarks.first);
      }
    } catch (e) {
      // Geocoding xatoligi
    }
    return null;
  }

  /// Placemark formatini chiqarish
  String _formatPlacemark(Placemark place) {
    final parts = <String>[];

    if (place.locality != null && place.locality!.isNotEmpty) {
      parts.add(place.locality!);
    } else if (place.administrativeArea != null &&
        place.administrativeArea!.isNotEmpty) {
      parts.add(place.administrativeArea!);
    }

    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      parts.add(place.subLocality!);
    } else if (place.subAdministrativeArea != null &&
        place.subAdministrativeArea!.isNotEmpty) {
      parts.add(place.subAdministrativeArea!);
    }

    return parts.isNotEmpty ? parts.join(', ') : 'Noma\'lum joy';
  }
}

/// Joylashuv ruxsati rad etilgan
class LocationPermissionDeniedException implements Exception {
  @override
  String toString() => 'Joylashuv ruxsati rad etildi';
}

/// GPS xizmati o'chirilgan
class LocationServiceDisabledException implements Exception {
  @override
  String toString() => 'GPS xizmati o\'chirilgan';
}
