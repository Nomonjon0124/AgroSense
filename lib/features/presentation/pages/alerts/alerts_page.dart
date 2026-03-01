import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum AlertFilter { all, critical, warning }
enum AlertCardType { critical, warning, resolved }

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  AlertFilter filter = AlertFilter.all;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final alerts = _buildAlerts(l10n);

    final filtered = alerts.where((alert) {
      if (filter == AlertFilter.all) return true;
      if (filter == AlertFilter.critical) return alert.type == AlertCardType.critical;
      return alert.type == AlertCardType.warning;
    }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.alertsTitle,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const Gap(6),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: colorScheme.primary,
                              ),
                              const Gap(6),
                              Text(
                                l10n.farmName,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _syncPill(context),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _filterBar(context),
              ),
              const Gap(16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    for (final alert in filtered) ...[
                      _AlertCard(data: alert),
                      const Gap(16),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _syncPill(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off_rounded, size: 12, color: colorScheme.onSurfaceVariant),
          const Gap(6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.offline,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.9),
                ),
              ),
              Text(
                l10n.lastSyncedAt('10:00 AM'),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          _FilterButton(
            label: l10n.all,
            selected: filter == AlertFilter.all,
            onTap: () => setState(() => filter = AlertFilter.all),
          ),
          _FilterButton(
            label: l10n.critical,
            selected: filter == AlertFilter.critical,
            onTap: () => setState(() => filter = AlertFilter.critical),
          ),
          _FilterButton(
            label: l10n.warning,
            selected: filter == AlertFilter.warning,
            onTap: () => setState(() => filter = AlertFilter.warning),
          ),
        ],
      ),
    );
  }

  List<_AlertData> _buildAlerts(AppLocalizations l10n) {
    return [
      _AlertData(
        type: AlertCardType.critical,
        title: l10n.frostWarning,
        level: l10n.extremeRisk,
        age: l10n.newLabel,
        description: '',
        cta: l10n.viewProtectionPlan,
        criticalDetails: [
          _AlertDetail(l10n.duration, l10n.tonightDuration, Icons.schedule_outlined),
          _AlertDetail(l10n.affectedAreas, l10n.affectedAreasValue, Icons.map_outlined),
        ],
      ),
      _AlertData(
        type: AlertCardType.warning,
        title: l10n.heavyRain,
        level: l10n.moderateRisk,
        age: l10n.oneHourAgo,
        description: l10n.heavyRainDescription,
        tags: [l10n.affectsLowlands, l10n.cornFieldB],
      ),
      _AlertData(
        type: AlertCardType.resolved,
        title: l10n.windGusts,
        level: '',
        age: l10n.threeHoursAgo,
        description: l10n.windDescription,
        footerStatus: l10n.resolved,
      ),
    ];
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? colorScheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            border: selected
                ? Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.7))
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              color: selected ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final _AlertData data;

  const _AlertCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final critical = data.type == AlertCardType.critical;
    final warning = data.type == AlertCardType.warning;
    final background = critical
        ? Colors.red.withValues(alpha: 0.05)
        : warning
            ? const Color(0xFFFFF7ED)
            : colorScheme.surface;
    final border = critical
        ? Colors.red.withValues(alpha: 0.22)
        : warning
            ? const Color(0xFFFFD6A7)
            : colorScheme.outlineVariant.withValues(alpha: 0.6);
    final titleColor = critical
        ? Colors.red.shade700
        : warning
            ? const Color(0xFF9F2D00)
            : colorScheme.onSurface;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: titleColor.withValues(alpha: 0.12),
                ),
                child: Icon(
                  critical
                      ? Icons.notifications_active_outlined
                      : warning
                          ? Icons.warning_amber_rounded
                          : Icons.air_outlined,
                  color: titleColor,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: titleColor,
                      ),
                    ),
                    if (data.level.isNotEmpty)
                      Text(
                        data.level.toUpperCase(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: titleColor.withValues(alpha: 0.75),
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                data.age,
                style: TextStyle(
                  fontSize: 13,
                  color: titleColor.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Gap(14),
          if (critical && data.criticalDetails != null)
            ...data.criticalDetails!.map((detail) => _CriticalDetailTile(detail: detail)),
          if (critical) const Gap(6),
          if (critical && data.cta != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {},
                child: Text(
                  data.cta!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          if (!critical) ...[
            Text(
              data.description,
              style: TextStyle(
                fontSize: 14,
                color: titleColor.withValues(alpha: 0.8),
                height: 1.4,
              ),
            ),
            const Gap(14),
            if (warning && data.tags != null)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: data.tags!
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEDD4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            color: Color(0xFFCA3500),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            if (data.type == AlertCardType.resolved && data.footerStatus != null)
              Text(
                data.footerStatus!,
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _CriticalDetailTile extends StatelessWidget {
  final _AlertDetail detail;

  const _CriticalDetailTile({required this.detail});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(detail.icon, color: colorScheme.error, size: 16),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.label,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  detail.value,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertData {
  final AlertCardType type;
  final String title;
  final String level;
  final String age;
  final String description;
  final String? cta;
  final List<_AlertDetail>? criticalDetails;
  final List<String>? tags;
  final String? footerStatus;

  _AlertData({
    required this.type,
    required this.title,
    required this.level,
    required this.age,
    required this.description,
    this.cta,
    this.criticalDetails,
    this.tags,
    this.footerStatus,
  });
}

class _AlertDetail {
  final String label;
  final String value;
  final IconData icon;

  _AlertDetail(this.label, this.value, this.icon);
}


