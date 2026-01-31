import 'package:equatable/equatable.dart';

/// Dashboard eventlari
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Dashboard ma'lumotlarini yuklash
class LoadDashboard extends DashboardEvent {
  final bool forceRefresh;

  const LoadDashboard({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

/// Ma'lumotlarni yangilash (pull-to-refresh)
class RefreshDashboard extends DashboardEvent {
  const RefreshDashboard();
}

/// Joylashuvni yangilash
class UpdateLocation extends DashboardEvent {
  const UpdateLocation();
}

/// Tarmoq holatini yangilash
class NetworkStatusChanged extends DashboardEvent {
  final bool isOnline;

  const NetworkStatusChanged({required this.isOnline});

  @override
  List<Object?> get props => [isOnline];
}
