import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/extensions/text_extensions.dart';
import '../../../../../core/utils/weather_code_helper.dart';

class WeatherCard extends StatelessWidget {
  final int temperature;
  final int weatherCode;
  final int humidity;
  final int windSpeed;
  final int precipitation;
  final bool isLiveData;
  final bool isDay;

  const WeatherCard({
    super.key,
    required this.temperature,
    required this.weatherCode,
    required this.humidity,
    required this.windSpeed,
    required this.precipitation,
    this.isLiveData = false,
    this.isDay = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final condition = WeatherCodeHelper.getShortCondition(weatherCode);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.weatherGradientStart,
            AppColors.weatherGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(77),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  l10n.currentWeather.s(14).w(500).c(Colors.white70),
                  const Gap(8),
                  if (isLiveData) _buildLiveBadge(context),
                ],
              ),
              Icon(
                WeatherCodeHelper.getIcon(weatherCode, isDay: isDay),
                size: 56,
                color: WeatherCodeHelper.getColor(weatherCode),
              ),
            ],
          ),
          const Gap(16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$temperature°', style: AppTextStyles.temperatureLarge),
              const Gap(12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    condition,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.weatherCondition.copyWith(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Gap(24),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              _buildInfoItem(
                icon: Icons.water_drop_outlined,
                label: l10n.humidityUpper,
                value: '$humidity%',
              ),
              _buildInfoItem(
                icon: Icons.air,
                label: l10n.windUpper,
                value: '$windSpeed km/h',
              ),
              _buildInfoItem(
                icon: Icons.umbrella_outlined,
                label: l10n.precipUpper,
                value: '$precipitation mm',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLiveBadge(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, size: 6, color: Colors.white),
          const Gap(6),
          l10n.liveData.s(10).w(600).c(Colors.white),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.white70),
            const Gap(4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.weatherLabel,
            ),
          ],
        ),
        const Gap(4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.weatherValue.copyWith(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
