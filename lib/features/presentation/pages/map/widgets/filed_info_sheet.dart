part of '../map_part.dart';

class FieldInfoSheet extends StatelessWidget {
  final FieldEntity field;
  final VoidCallback onClose;
  final VoidCallback onViewAnalysis;

  const FieldInfoSheet({
    super.key,
    required this.field,
    required this.onClose,
    required this.onViewAnalysis,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        field.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const Gap(8),
                    Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const Gap(4),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.hectares(field.areaHectares.toString()),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  field.currentStage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const Gap(20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              StatCard(
                icon: Icons.water_drop_outlined,
                label: l10n.metricMoisture,
                value: '${field.moisture}%',
                color: _getMoistureColor(field.moisture),
              ),
              const Gap(12),
              StatCard(
                icon: Icons.thermostat_outlined,
                label: l10n.metricSoilT,
                value: '${field.soilTemperature.round()}°C',
                color: colorScheme.onSurface,
              ),
              StatCard(
                icon: Icons.healing_outlined,
                label: l10n.metricHealth,
                value: '${field.healthPercentage}%',
                color: _getHealthColor(field.healthPercentage),
              ),
            ],
          ),
          const Gap(20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onViewAnalysis,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      l10n.viewFullAnalysis,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
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
