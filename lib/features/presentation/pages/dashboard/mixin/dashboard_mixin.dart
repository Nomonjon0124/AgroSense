part of '../dashboard_part.dart';

mixin DashboardMixin on State<DashboardView> {
  Widget _buildContent(
    BuildContext context,
    DashboardData data, {
    bool isLoading = false,
    String? errorMessage,
  }) {
    final currentWeather = data.currentWeather;
    final dailyWeather = data.dailyWeather;
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(16),

                /// Header - Salomlashish va offline status
                DashboardHeader(
                  greeting: data.greeting,
                  location: data.location.formattedAddress,
                  isOffline: !data.isOnline,
                  lastSyncTime: data.lastSyncTime,
                ),

                const Gap(24),

                /// Joriy ob-havo kartasi
                if (currentWeather != null)
                  WeatherCard(
                    temperature: currentWeather.temperature.round(),
                    weatherCode: currentWeather.weatherCode,
                    humidity: currentWeather.relativeHumidity,
                    windSpeed: currentWeather.windSpeed.round(),
                    precipitation: currentWeather.precipitation.round(),
                    isLiveData: data.isOnline && !data.isFromCache,
                    isDay: currentWeather.isDay,
                  ),

                const Gap(24),

                /// 7 kunlik prognoz
                if (dailyWeather != null)
                  ForecastSection(dailyWeather: dailyWeather),

                const Gap(24),

                /// Dala holati
                const FieldStatusSection(),

                const Gap(24),
              ],
            ),
          ),
        ),

        // Loading indicator (ma'lumot bor paytdagi loading)
        if (isLoading)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              color: colorScheme.primary,
            ),
          ),

        // Xato xabari (snackbar style)
        if (errorMessage != null)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const Gap(12),
                    Expanded(
                      child: Text(
                        errorMessage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<DashboardBloc>().add(
                          const LoadDashboard(),
                        );
                      },
                      icon: const Icon(Icons.refresh, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
