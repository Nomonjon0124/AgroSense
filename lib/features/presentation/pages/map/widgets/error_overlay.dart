part of '../map_part.dart';

class ErrorOverlay extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorOverlay({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalMargin = constraints.maxWidth < 360 ? 18.0 : 28.0;
              return Container(
                margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer.withValues(
                          alpha: 0.5,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline,
                        color: colorScheme.error,
                        size: 32,
                      ),
                    ),
                    const Gap(16),
                    l10n.mapErrorTitle.s(17).w(600).c(colorScheme.onSurface),
                    const Gap(8),
                    Text(
                      localizedMessage,
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(18),
                    ElevatedButton(
                      onPressed: onRetry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 11,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
