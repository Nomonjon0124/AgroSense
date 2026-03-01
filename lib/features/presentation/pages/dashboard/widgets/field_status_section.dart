import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/extensions/text_extensions.dart';

class FieldStatusSection extends StatelessWidget {
  const FieldStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        l10n.fieldStatusTitle.s(18).w(700).c(AppColors.textPrimary),
        const Gap(16),
        FieldStatusCard(
          fieldName: l10n.fieldWheatA,
          icon: Icons.grass,
          iconBackgroundColor: const Color(0xFFFFF3E0),
          iconColor: const Color(0xFFFF9800),
          statusText: l10n.statusMoisture22,
          statusType: FieldStatusType.warning,
          actionLabel: l10n.actionWater,
          onActionTap: () {},
        ),
        const Gap(12),
        FieldStatusCard(
          fieldName: l10n.fieldCornB,
          icon: Icons.eco,
          iconBackgroundColor: const Color(0xFFE8F5E9),
          iconColor: const Color(0xFF4CAF50),
          statusText: l10n.statusMoisture45,
          statusType: FieldStatusType.good,
          actionLabel: l10n.actionGood,
        ),
        const Gap(12),
        FieldStatusCard(
          fieldName: l10n.fieldSoybeanPlot,
          icon: Icons.spa,
          iconBackgroundColor: const Color(0xFFF5F5F5),
          iconColor: const Color(0xFF9E9E9E),
          statusText: l10n.statusReadyIn2Days,
          statusType: FieldStatusType.waiting,
          actionLabel: l10n.actionWait,
        ),
      ],
    );
  }
}

enum FieldStatusType { good, warning, waiting }

class FieldStatusCard extends StatelessWidget {
  final String fieldName;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String statusText;
  final FieldStatusType statusType;
  final String actionLabel;
  final VoidCallback? onActionTap;

  const FieldStatusCard({
    super.key,
    required this.fieldName,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.statusText,
    required this.statusType,
    required this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                fieldName.s(16).w(600).c(AppColors.textPrimary),
                const Gap(4),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _getStatusDotColor(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Gap(6),
                    statusText.s(13).c(AppColors.textSecondary),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onActionTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getActionBackgroundColor(),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _getActionBorderColor(), width: 1),
              ),
              child: Text(
                actionLabel,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _getActionTextColor(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusDotColor() {
    switch (statusType) {
      case FieldStatusType.good:
        return AppColors.success;
      case FieldStatusType.warning:
        return AppColors.warning;
      case FieldStatusType.waiting:
        return AppColors.textTertiary;
    }
  }

  Color _getActionBackgroundColor() {
    switch (statusType) {
      case FieldStatusType.good:
        return AppColors.primarySurface;
      case FieldStatusType.warning:
        return AppColors.surface;
      case FieldStatusType.waiting:
        return AppColors.background;
    }
  }

  Color _getActionBorderColor() {
    switch (statusType) {
      case FieldStatusType.good:
        return AppColors.success;
      case FieldStatusType.warning:
        return AppColors.warning;
      case FieldStatusType.waiting:
        return AppColors.border;
    }
  }

  Color _getActionTextColor() {
    switch (statusType) {
      case FieldStatusType.good:
        return AppColors.primary;
      case FieldStatusType.warning:
        return AppColors.warning;
      case FieldStatusType.waiting:
        return AppColors.textSecondary;
    }
  }
}

