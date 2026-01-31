part of '../map_part.dart';

class FieldInfoSheet extends StatelessWidget {
  final FieldEntity field;
  final VoidCallback onClose;
  final VoidCallback onViewAnalysis;

  const FieldInfoSheet({super.key,
    required this.field,
    required this.onClose,
    required this.onViewAnalysis,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    field.name.s(18).w(700).c(AppColors.textPrimary),
                    const Gap(8),
                    const Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          const Gap(4),

          /// Subtitle
          Row(
            children: [
              '${field.areaHectares} Hectares'.s(14).c(AppColors.textSecondary),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.textTertiary,
                  shape: BoxShape.circle,
                ),
              ),
              field.currentStage.s(14).c(AppColors.textSecondary),
            ],
          ),

          const Gap(20),

          /// Stats Row
          Row(
            children: [
              StatCard(
                icon: Icons.water_drop_outlined,
                label: 'MOISTURE',
                value: '${field.moisture}%',
                color: _getMoistureColor(field.moisture),
              ),
              const Gap(12),
              StatCard(
                icon: Icons.thermostat_outlined,
                label: 'SOIL T',
                value: '${field.soilTemperature.round()}°C',
                color: AppColors.textPrimary,
              ),
              const Gap(12),
              StatCard(
                icon: Icons.healing_outlined,
                label: 'HEALTH',
                value: '${field.healthPercentage}%',
                color: _getHealthColor(field.healthPercentage),
              ),
            ],
          ),

          const Gap(20),

          /// View Full Analysis Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onViewAnalysis,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  'View Full Analysis'.s(14).w(600).c(Colors.white),
                  const Gap(8),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getMoistureColor(int moisture) {
    if (moisture < 25) return AppColors.warning;
    if (moisture < 60) return AppColors.success;
    return AppColors.info;
  }

  Color _getHealthColor(int health) {
    if (health < 50) return AppColors.error;
    if (health < 80) return AppColors.warning;
    return AppColors.success;
  }
}