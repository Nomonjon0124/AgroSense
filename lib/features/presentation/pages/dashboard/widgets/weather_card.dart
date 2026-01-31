import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/extensions/text_extensions.dart';
import '../../../../../core/utils/weather_code_helper.dart';

/// Joriy ob-havo kartasi
/// Figma dizayniga mos yashil gradient karta
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
          /// Header - Current Weather va Live Data badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  'Current Weather'.s(14).w(500).c(Colors.white70),
                  const Gap(8),
                  if (isLiveData) _buildLiveBadge(),
                ],
              ),

              /// Ob-havo ikonkasi
              Icon(
                WeatherCodeHelper.getIcon(weatherCode, isDay: isDay),
                size: 56,
                color: WeatherCodeHelper.getColor(weatherCode),
              ),
            ],
          ),

          const Gap(16),

          /// Harorat va holat
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$temperature°', style: AppTextStyles.temperatureLarge),
              const Gap(12),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(condition, style: AppTextStyles.weatherCondition),
              ),
            ],
          ),

          const Gap(24),

          /// Qo'shimcha ma'lumotlar
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildInfoItem(
                icon: Icons.water_drop_outlined,
                label: 'HUMIDITY',
                value: '$humidity%',
              ),
              const Gap(32),
              _buildInfoItem(
                icon: Icons.air,
                label: 'WIND',
                value: '$windSpeed km/h',
              ),
              const Gap(32),
              _buildInfoItem(
                icon: Icons.umbrella_outlined,
                label: 'PRECIP',
                value: '$precipitation mm',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLiveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.success,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, size: 6, color: Colors.white),
          const Gap(6),
          'Live Data'.s(11).w(600).c(Colors.white),
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
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.white70),
            const Gap(4),
            Text(label, style: AppTextStyles.weatherLabel),
          ],
        ),
        const Gap(4),
        Text(value, style: AppTextStyles.weatherValue),
      ],
    );
  }
}
