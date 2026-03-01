import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// Dashboard header widgeti
/// Salomlashish, joylashuv va offline status ko'rsatadi
class DashboardHeader extends StatelessWidget {
  final String greeting;
  final String location;
  final bool isOffline;
  final String lastSyncTime;

  const DashboardHeader({
    super.key,
    required this.greeting,
    required this.location,
    required this.isOffline,
    required this.lastSyncTime,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    String localizedGreeting;
    switch (greeting) {
      case 'greeting.morning':
        localizedGreeting = l10n.greetingMorning;
        break;
      case 'greeting.afternoon':
        localizedGreeting = l10n.greetingAfternoon;
        break;
      case 'greeting.evening':
        localizedGreeting = l10n.greetingEvening;
        break;
      case 'greeting.night':
        localizedGreeting = l10n.greetingNight;
        break;
      default:
        localizedGreeting = greeting;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Salomlashish va joylashuv
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizedGreeting,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const Gap(4),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const Gap(4),
                  Expanded(
                    child: Text(
                      location,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const Gap(6),

        /// Offline status badge
        Flexible(
          fit: FlexFit.loose,
          child: Align(
            alignment: Alignment.topRight,
            child: _buildStatusBadge(context),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isOffline ? AppColors.offline : AppColors.online,
              shape: BoxShape.circle,
            ),
          ),
          const Gap(8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isOffline ? l10n.offline : l10n.online,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  l10n.lastSyncedAt(lastSyncTime),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
