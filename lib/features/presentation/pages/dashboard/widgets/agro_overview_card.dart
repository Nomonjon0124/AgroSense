import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/extensions/text_extensions.dart';

/// AgroTech umumiy ko'rinish kartasi
class AgroOverviewCard extends StatefulWidget {
  final double temperature;
  final String weatherCondition;
  final int airHumidity;
  final int soilMoisture;
  final String soilFertility;
  final String location;

  const AgroOverviewCard({
    super.key,
    required this.temperature,
    required this.weatherCondition,
    required this.airHumidity,
    required this.soilMoisture,
    required this.soilFertility,
    required this.location,
  });

  @override
  State<AgroOverviewCard> createState() => _AgroOverviewCardState();
}

class _AgroOverviewCardState extends State<AgroOverviewCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.1, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Agro Monitor',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                const Gap(8),
                _buildLocationChip(colorScheme),
              ],
            ),
            const Gap(12),
            _buildMainAgroCard(colorScheme),
            const Gap(12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    colorScheme,
                    title: 'Tuproq namligi',
                    value: '${widget.soilMoisture}%',
                    icon: Icons.water_drop_rounded,
                    progress: widget.soilMoisture / 100,
                    progressColor: _getSoilMoistureColor(widget.soilMoisture),
                    subtitle: _getSoilMoistureStatus(widget.soilMoisture),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: _buildMetricCard(
                    colorScheme,
                    title: 'Havo namligi',
                    value: '${widget.airHumidity}%',
                    icon: Icons.cloud_outlined,
                    progress: widget.airHumidity / 100,
                    progressColor: _getAirHumidityColor(widget.airHumidity),
                    subtitle: _getAirHumidityStatus(widget.airHumidity),
                  ),
                ),
              ],
            ),
            const Gap(10),
            _buildFertilityCard(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationChip(ColorScheme colorScheme) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 130),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on_rounded, size: 13, color: colorScheme.primary),
          const Gap(4),
          Flexible(
            child: Text(
              widget.location,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainAgroCard(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF388E3C)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    'Harorat'.s(13).w(500).c(Colors.white70),
                    const Gap(6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.temperature.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            '°C',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(8),
              Container(
                constraints: const BoxConstraints(maxWidth: 120),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _getWeatherLabel(widget.weatherCondition),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniStat(
                icon: Icons.water_drop_rounded,
                label: 'Tuproq',
                value: '${widget.soilMoisture}%',
              ),
              _buildMiniStat(
                icon: Icons.cloud_rounded,
                label: 'Namlik',
                value: '${widget.airHumidity}%',
              ),
              _buildMiniStat(
                icon: Icons.eco_rounded,
                label: 'Tuproq',
                value: 'Yaxshi',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Flexible(
      child: Column(
        children: [
          Icon(icon, size: 16, color: Colors.white60),
          const Gap(3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 9, color: Colors.white54),
          ),
          const Gap(2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    ColorScheme colorScheme, {
    required String title,
    required String value,
    required IconData icon,
    required double progress,
    required Color progressColor,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: progressColor),
              const Spacer(),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const Gap(10),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
          ),
          const Gap(6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: progress.clamp(0.0, 1.0),
              color: progressColor,
              backgroundColor: progressColor.withValues(alpha: 0.2),
            ),
          ),
          const Gap(6),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              color: progressColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFertilityCard(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFA5D6A7), Color(0xFF66BB6A)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.spa_rounded, color: Colors.white, size: 24),
          ),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tuproq unumdorligi',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  widget.soilFertility,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Gap(8),
          Container(
            constraints: const BoxConstraints(maxWidth: 84),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF4CAF50).withValues(alpha: 0.6),
              ),
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Yaxshi',
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getSoilMoistureColor(int moisture) {
    if (moisture < 20) return AppColors.error;
    if (moisture < 35) return AppColors.warning;
    if (moisture < 60) return const Color(0xFF43A047);
    return const Color(0xFF1565C0);
  }

  String _getSoilMoistureStatus(int moisture) {
    if (moisture < 20) return 'Juda quruq';
    if (moisture < 35) return 'Sug\'orish kerak';
    if (moisture < 60) return 'Me\'yorida';
    return 'Yuqori namlik';
  }

  Color _getAirHumidityColor(int humidity) {
    if (humidity < 30) return AppColors.warning;
    if (humidity < 60) return const Color(0xFF43A047);
    if (humidity < 80) return const Color(0xFF1565C0);
    return const Color(0xFF5C6BC0);
  }

  String _getAirHumidityStatus(int humidity) {
    if (humidity < 30) return 'Quruq havo';
    if (humidity < 60) return 'Qulay';
    if (humidity < 80) return 'Namchil';
    return 'Juda namchil';
  }

  String _getWeatherLabel(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('clear')) return 'Ochiq havo';
    if (lower.contains('few') || lower.contains('partly')) {
      return 'Qisman bulutli';
    }
    if (lower.contains('scattered')) return 'Bulutli';
    if (lower.contains('broken')) return 'Qisman bulutli';
    if (lower.contains('overcast')) return 'To\'liq bulutli';
    if (lower.contains('rain') || lower.contains('drizzle')) {
      return 'Yomg\'irli';
    }
    if (lower.contains('snow')) return 'Qorli';
    if (lower.contains('thunder')) return 'Momaqaldiroq';
    if (lower.contains('fog') || lower.contains('mist')) return 'Tumanli';
    return 'Bulutli';
  }
}
