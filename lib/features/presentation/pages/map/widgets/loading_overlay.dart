part of '../map_part.dart';

class LoadingOverlay extends StatelessWidget {
  final int progress;
  final String message;

  const LoadingOverlay({super.key, required this.progress, required this.message});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String localizedMessage;
    switch (message) {
      case 'map.loading.preparing':
        localizedMessage = l10n.mapLoadingPreparing;
        break;
      case 'map.loading.checkingNetwork':
        localizedMessage = l10n.mapLoadingCheckingNetwork;
        break;
      case 'map.loading.determiningLocation':
        localizedMessage = l10n.mapLoadingDeterminingLocation;
        break;
      case 'map.loading.loadingMap':
        localizedMessage = l10n.mapLoadingLoadingMap;
        break;
      case 'map.loading.loadingFields':
        localizedMessage = l10n.mapLoadingLoadingFields;
        break;
      case 'map.loading.loadingWeather':
        localizedMessage = l10n.mapLoadingLoadingWeather;
        break;
      case 'map.loading.ready':
        localizedMessage = l10n.mapLoadingReady;
        break;
      default:
        localizedMessage = message;
    }

    return Container(
      color: Colors.black.withAlpha(100),
      child: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 48),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(30), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Animated Icon
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: progress / 100),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(value: value, strokeWidth: 6, backgroundColor: AppColors.border, color: AppColors.primary),
                        ),
                        Column(mainAxisSize: MainAxisSize.min, children: ['$progress%'.s(18).w(700).c(AppColors.primary)]),
                      ],
                    );
                  },
                ),

                const Gap(24),

                /// Loading message
                Text(
                  localizedMessage,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),

                const Gap(8),

                /// Progress steps
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProgressDot(isActive: progress >= 0, isCompleted: progress >= 30),
                    ProgressLine(isCompleted: progress >= 30),
                    ProgressDot(isActive: progress >= 30, isCompleted: progress >= 70),
                    ProgressLine(isCompleted: progress >= 70),
                    ProgressDot(isActive: progress >= 70, isCompleted: progress >= 100),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
