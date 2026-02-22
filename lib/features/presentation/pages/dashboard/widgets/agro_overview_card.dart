import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/extensions/text_extensions.dart';

/// AgroTech umumiy ko'rinish kartasi
/// Ob-havo va tuproq ma'lumotlarini premium dizaynda ko'rsatadi
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
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.1, 0.7, curve: Curves.easeOutCubic),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Section sarlavhasi
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF43A047), Color(0xFF1B5E20)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Gap(10),
              'Agro Monitor'.s(20).w(700).c(AppColors.textPrimary),
              const Spacer(),
              _buildLocationChip(),
            ],
          ),

          const Gap(16),

          /// Asosiy agro karta — gradient fon bilan
          _buildMainAgroCard(),

          const Gap(16),

          /// Tuproq & Havo ko'rsatkichlari
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'Tuproq namligi',
                  value: '${widget.soilMoisture}%',
                  icon: Icons.water_drop_rounded,
                  progress: widget.soilMoisture / 100,
                  progressColor: _getSoilMoistureColor(widget.soilMoisture),
                  bgColor: const Color(0xFFE3F2FD),
                  iconColor: const Color(0xFF1565C0),
                  subtitle: _getSoilMoistureStatus(widget.soilMoisture),
                ),
              ),
              const Gap(12),
              Expanded(
                child: _buildMetricCard(
                  title: 'Havo namligi',
                  value: '${widget.airHumidity}%',
                  icon: Icons.cloud_outlined,
                  progress: widget.airHumidity / 100,
                  progressColor: _getAirHumidityColor(widget.airHumidity),
                  bgColor: const Color(0xFFFFF3E0),
                  iconColor: const Color(0xFFE65100),
                  subtitle: _getAirHumidityStatus(widget.airHumidity),
                ),
              ),
            ],
          ),

          const Gap(12),

          /// Tuproq unumdorligi kartasi
          _buildFertilityCard(),
        ],
      ),
    );
  }

  /// Joylashuv chipi
  Widget _buildLocationChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryLight.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.location_on_rounded,
            size: 14,
            color: AppColors.primary,
          ),
          const Gap(4),
          widget.location.s(12).w(600).c(AppColors.primary),
        ],
      ),
    );
  }

  /// Asosiy gradient karta — harorat va ob-havo holati
  Widget _buildMainAgroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF388E3C)],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withAlpha(60),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: const Color(0xFF1B5E20).withAlpha(30),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          /// Dekorativ doiralar (glassmorphism effekti)
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(15),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -10,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(10),
              ),
            ),
          ),

          /// Kontent
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Harorat
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.thermostat_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const Gap(10),
                            'Harorat'.s(14).w(500).c(Colors.white70),
                          ],
                        ),
                        const Gap(12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.temperature.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w200,
                                color: Colors.white,
                                height: 1,
                                letterSpacing: -2,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Text(
                                '°C',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// Ob-havo ikonkasi & holati
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(20),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withAlpha(15)),
                        ),
                        child: Icon(
                          _getWeatherIcon(widget.weatherCondition),
                          size: 36,
                          color: _getWeatherIconColor(widget.weatherCondition),
                        ),
                      ),
                      const Gap(10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(20),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: _getWeatherLabel(
                          widget.weatherCondition,
                        ).s(12).w(500).c(Colors.white),
                      ),
                    ],
                  ),
                ],
              ),

              const Gap(20),

              /// Pastki qism — separator + mini ma'lumotlar
              Container(
                padding: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.white.withAlpha(30)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMiniStat(
                      icon: Icons.water_drop_rounded,
                      label: 'Tuproq',
                      value: '${widget.soilMoisture}%',
                    ),
                    Container(
                      width: 1,
                      height: 32,
                      color: Colors.white.withAlpha(30),
                    ),
                    _buildMiniStat(
                      icon: Icons.cloud_rounded,
                      label: 'Namlik',
                      value: '${widget.airHumidity}%',
                    ),
                    Container(
                      width: 1,
                      height: 32,
                      color: Colors.white.withAlpha(30),
                    ),
                    _buildMiniStat(
                      icon: Icons.eco_rounded,
                      label: 'Tuproq',
                      value: 'Yaxshi',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Mini statistika elementi (asosiy kartaning pastki qismida)
  Widget _buildMiniStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 18, color: Colors.white60),
        const Gap(4),
        label.s(10).w(500).c(Colors.white54),
        const Gap(2),
        value.s(14).w(700).c(Colors.white),
      ],
    );
  }

  /// Metrik karta (tuproq namligi / havo namligi)
  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required double progress,
    required Color progressColor,
    required Color bgColor,
    required Color iconColor,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const Spacer(),
              value.s(22).w(700).c(AppColors.textPrimary),
            ],
          ),
          const Gap(14),
          title.s(12).w(500).c(AppColors.textSecondary),
          const Gap(8),

          /// Progress bar
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: progressColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [progressColor.withAlpha(180), progressColor],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),

          const Gap(8),
          subtitle.s(11).w(500).c(progressColor),
        ],
      ),
    );
  }

  /// Tuproq unumdorligi kartasi
  Widget _buildFertilityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border.withAlpha(80)),
      ),
      child: Row(
        children: [
          /// NPK ikonka
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFA5D6A7), Color(0xFF66BB6A)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF66BB6A).withAlpha(40),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.spa_rounded, color: Colors.white, size: 28),
          ),
          const Gap(16),

          /// Ma'lumot
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                'Tuproq unumdorligi'.s(14).w(600).c(AppColors.textPrimary),
                const Gap(4),
                widget.soilFertility.s(13).w(500).c(AppColors.textSecondary),
              ],
            ),
          ),

          /// Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF4CAF50).withAlpha(60)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  size: 16,
                  color: Color(0xFF2E7D32),
                ),
                const Gap(6),
                'Yaxshi'.s(13).w(600).c(const Color(0xFF2E7D32)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // === Yordamchi metodlar ===

  Color _getSoilMoistureColor(int moisture) {
    if (moisture < 20) return AppColors.error;
    if (moisture < 35) return AppColors.warning;
    if (moisture < 60) return const Color(0xFF43A047);
    return const Color(0xFF1565C0);
  }

  String _getSoilMoistureStatus(int moisture) {
    if (moisture < 20) return '⚠️ Juda quruq';
    if (moisture < 35) return '💧 Sug\'orish kerak';
    if (moisture < 60) return '✅ Me\'yorida';
    return '💦 Yuqori namlik';
  }

  Color _getAirHumidityColor(int humidity) {
    if (humidity < 30) return AppColors.warning;
    if (humidity < 60) return const Color(0xFF43A047);
    if (humidity < 80) return const Color(0xFF1565C0);
    return const Color(0xFF5C6BC0);
  }

  String _getAirHumidityStatus(int humidity) {
    if (humidity < 30) return '🏜️ Quruq havo';
    if (humidity < 60) return '✅ Qulay';
    if (humidity < 80) return '💧 Namchil';
    return '🌧️ Juda namchil';
  }

  IconData _getWeatherIcon(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('clear') || lower.contains('sunny')) {
      return Icons.wb_sunny_rounded;
    }
    if (lower.contains('partly') || lower.contains('few')) {
      return Icons.wb_cloudy;
    }
    if (lower.contains('cloud') ||
        lower.contains('overcast') ||
        lower.contains('broken')) {
      return Icons.cloud_rounded;
    }
    if (lower.contains('rain') ||
        lower.contains('drizzle') ||
        lower.contains('shower')) {
      return Icons.water_drop_rounded;
    }
    if (lower.contains('snow')) return Icons.ac_unit_rounded;
    if (lower.contains('thunder') || lower.contains('storm')) {
      return Icons.thunderstorm_rounded;
    }
    if (lower.contains('fog') ||
        lower.contains('mist') ||
        lower.contains('haze')) {
      return Icons.foggy;
    }
    return Icons.wb_cloudy;
  }

  Color _getWeatherIconColor(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('clear') || lower.contains('sunny')) {
      return const Color(0xFFFFD54F);
    }
    if (lower.contains('cloud') ||
        lower.contains('overcast') ||
        lower.contains('broken')) {
      return Colors.white70;
    }
    if (lower.contains('rain') || lower.contains('drizzle')) {
      return const Color(0xFF90CAF9);
    }
    if (lower.contains('snow')) return Colors.white;
    if (lower.contains('thunder')) return const Color(0xFFFFD54F);
    return Colors.white70;
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
