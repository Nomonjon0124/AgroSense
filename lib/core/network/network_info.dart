import 'package:connectivity_plus/connectivity_plus.dart';

/// Network holatini tekshiruvchi abstrakt interface
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
  Future<NetworkType> get networkType;
}

/// NetworkInfo implementatsiyasi
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return _isConnectedResult(result);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return connectivity.onConnectivityChanged.map(_isConnectedResult);
  }

  @override
  Future<NetworkType> get networkType async {
    final result = await connectivity.checkConnectivity();
    return _mapConnectivityToNetworkType(result);
  }

  bool _isConnectedResult(List<ConnectivityResult> result) {
    return result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet);
  }

  NetworkType _mapConnectivityToNetworkType(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.wifi)) {
      return NetworkType.wifi;
    } else if (result.contains(ConnectivityResult.mobile)) {
      return NetworkType.mobile;
    } else if (result.contains(ConnectivityResult.ethernet)) {
      return NetworkType.ethernet;
    } else {
      return NetworkType.none;
    }
  }
}

/// Network turi
enum NetworkType {
  wifi,
  mobile,
  ethernet,
  none,
}

extension NetworkTypeExtension on NetworkType {
  String get displayName {
    switch (this) {
      case NetworkType.wifi:
        return 'Wi-Fi';
      case NetworkType.mobile:
        return 'Mobile';
      case NetworkType.ethernet:
        return 'Ethernet';
      case NetworkType.none:
        return 'No Connection';
    }
  }

  bool get isConnected => this != NetworkType.none;
}