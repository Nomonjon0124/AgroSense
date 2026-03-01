import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/extensions/text_extensions.dart';

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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Salomlashish va joylashuv
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              localizedGreeting.s(24).w(700).c(AppColors.textPrimary),
              const Gap(4),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const Gap(4),
                  Expanded(
                    child: Text(
                      location,
                      style: AppTextStyles.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const Gap(8),

        /// Offline status badge
        _buildStatusBadge(context),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              (isOffline ? l10n.offline : l10n.online)
                  .s(10)
                  .w(700)
                  .c(AppColors.textSecondary),
              l10n.lastSyncedAt(lastSyncTime).s(9).c(AppColors.textTertiary),
            ],
          ),
        ],
      ),
    );
  }
}
