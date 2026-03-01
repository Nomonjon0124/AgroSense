part of '../map_part.dart';

class ErrorOverlay extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorOverlay({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String localizedMessage;
    switch (message) {
      case 'map.error.locationPermission':
        localizedMessage = l10n.mapErrorLocationPermission;
        break;
      case 'map.error.locationServiceDisabled':
        localizedMessage = l10n.mapErrorLocationServiceDisabled;
        break;
      default:
        localizedMessage = message;
    }
    return Container(
      color: Colors.black.withAlpha(100),
      child: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.error.withAlpha(26),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 32,
                  ),
                ),
                const Gap(16),
                l10n.mapErrorTitle.s(18).w(600).c(AppColors.textPrimary),
                const Gap(8),
                Text(
                  localizedMessage,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(20),
                ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
