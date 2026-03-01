import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../config/router/app_router.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.92),
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.45),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontal = constraints.maxWidth < 360 ? 12.0 : 24.0;
            return Padding(
              padding: EdgeInsets.fromLTRB(horizontal, 10, horizontal, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavBarItem(
                    icon: Icons.grid_view_rounded,
                    label: l10n.navDashboard,
                    route: AppRoutes.dashboard,
                  ),
                  _NavBarItem(
                    icon: Icons.map_outlined,
                    label: l10n.navMap,
                    route: AppRoutes.map,
                  ),
                  _NavBarItem(
                    icon: Icons.notifications_none_rounded,
                    label: l10n.navAlerts,
                    route: AppRoutes.alerts,
                    badgeCount: 1,
                  ),
                  _NavBarItem(
                    icon: Icons.settings_outlined,
                    label: l10n.navSettings,
                    route: AppRoutes.settings,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final int? badgeCount;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.route,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final isActive = currentLocation == route;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        if (!isActive) context.go(route);
      },
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 62,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color:
                      isActive
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                ),
                if (badgeCount != null && badgeCount! > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                if (isActive)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.surface,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color:
                    isActive
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
