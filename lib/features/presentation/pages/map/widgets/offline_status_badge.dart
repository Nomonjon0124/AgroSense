part of '../map_part.dart';

class OfflineStatusBadge extends StatelessWidget {
  final bool isOnline;
  final String cachedTimeAgo;

  const OfflineStatusBadge({super.key, required this.isOnline, required this.cachedTimeAgo});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: isOnline ? AppColors.online : AppColors.offline, shape: BoxShape.circle)),
          const Gap(8),
          (isOnline ? l10n.onlineMap : l10n.offlineMapActive).s(12).w(700).c(isOnline ? AppColors.primary : AppColors.textPrimary),
          const Gap(12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
            child: l10n.cachedUpper(cachedTimeAgo).s(10).w(500).c(AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
