import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/presentation/pages/dashboard/dashboard_part.dart';
import '../../features/presentation/pages/main_shell_page.dart';
import '../../features/presentation/pages/alerts/alerts_page.dart';
import '../../features/presentation/pages/map/map_part.dart';
import '../../features/presentation/pages/settings/settings_part.dart';

/// Route nomlari
abstract class AppRoutes {
  static const String dashboard = '/dashboard';
  static const String map = '/map';
  static const String alerts = '/alerts';
  static const String settings = '/settings';
}

/// GoRouter navigatsiya konfiguratsiyasi
class AppRouter {
  AppRouter._();

  /// Navigator kaliti
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  /// Router instansiyasi
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.dashboard,
    debugLogDiagnostics: true,
    routes: [
      /// Shell Route - Bottom Navigation bilan asosiy sahifalar
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainShellPage(child: child);
        },
        routes: [
          /// Dashboard sahifasi
          GoRoute(
            path: AppRoutes.dashboard,
            name: 'dashboard',
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: DashboardPage()),
          ),

          /// Map sahifasi
          GoRoute(
            path: AppRoutes.map,
            name: 'map',
            pageBuilder:
                (context, state) => const NoTransitionPage(child: MapPage()),
          ),

          /// Alerts sahifasi
          GoRoute(
            path: AppRoutes.alerts,
            name: 'alerts',
            pageBuilder:
                (context, state) => const NoTransitionPage(child: AlertsPage()),
          ),

          /// Settings sahifasi
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: SettingsPage()),
          ),
        ],
      ),
    ],
    errorPageBuilder:
        (context, state) => MaterialPage(
          child: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Sahifa topilmadi',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.uri.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go(AppRoutes.dashboard),
                    child: const Text('Bosh sahifaga qaytish'),
                  ),
                ],
              ),
            ),
          ),
        ),
  );
}
