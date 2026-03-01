import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/extensions/text_extensions.dart';
import '../../../../../core/utils/weather_code_helper.dart';
import '../../../../weather/domain/entities/weather_entity.dart';

/// 7 kunlik prognoz bo'limi
class ForecastSection extends StatefulWidget {
  final DailyWeatherEntity dailyWeather;

  const ForecastSection({super.key, required this.dailyWeather});

  @override
  State<ForecastSection> createState() => _ForecastSectionState();
}

class _ForecastSectionState extends State<ForecastSection> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            l10n.forecastTitle.s(18).w(700).c(AppColors.textPrimary),
            TextButton(
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  l10n.seeAll.s(14).w(500).c(AppColors.primary),
                  const Gap(4),
                  const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap(12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: List.generate(widget.dailyWeather.time.length, (index) {
              final snapshot = widget.dailyWeather.getSnapshotAt(index);
              if (snapshot == null) return const SizedBox.shrink();

              return Padding(
                padding: EdgeInsets.only(
                  right: index < widget.dailyWeather.time.length - 1 ? 12 : 0,
                ),
                child: _ForecastDayCard(
                  day: WeatherCodeHelper.getDayName(snapshot.time),
                  temperature: snapshot.temperatureMax.round(),
                  weatherCode: snapshot.weatherCode,
                  isSelected: index == _selectedIndex,
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _ForecastDayCard extends StatelessWidget {
  final String day;
  final int temperature;
  final int weatherCode;
  final bool isSelected;
  final VoidCallback? onTap;

  const _ForecastDayCard({
    required this.day,
    required this.temperature,
    required this.weatherCode,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySurface : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: AppColors.primaryLight, width: 1.5)
              : Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            const Gap(8),
            Icon(
              WeatherCodeHelper.getIcon(weatherCode),
              size: 28,
              color: WeatherCodeHelper.getColor(weatherCode),
            ),
            const Gap(8),
            Text(
              '$temperature°',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

