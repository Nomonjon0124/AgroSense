part of 'settings_part.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsView();
  }
}

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> with SettingsMixin {
  static const int _storageBudgetBytes = 2 * 1024 * 1024 * 1024;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocListener<SettingsBloc, SettingsState>(
        listenWhen:
            (previous, current) =>
                previous.errorMessage != current.errorMessage &&
                current.errorMessage != null,
        listener: (context, state) {
          final message = state.errorMessage;
          if (message == null) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_localizeError(context, message))),
          );
          context.read<SettingsBloc>().add(const ErrorShown());
        },
        child: SafeArea(
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.settingsTitle,
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const Gap(8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.tune,
                                      size: 14,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    const Gap(6),
                                    Expanded(
                                      child: Text(
                                        l10n.appPreferences,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Gap(12),
                          _statusPill(context, state),
                        ],
                      ),
                    ),
                    _sectionTitle(context, l10n.languageAndRegion),
                    const Gap(12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          _languageCard(
                            context,
                            title: 'English',
                            flag: Assets.icons.icUsa,
                            selected: state.locale.languageCode == 'en',
                            onTap: () {
                              context.read<SettingsBloc>().add(
                                const LanguageChanged(Locale('en')),
                              );
                            },
                          ),
                          const Gap(12),
                          _languageCard(
                            context,
                            title: 'Russian',
                            flag: Assets.icons.icRu,
                            selected: state.locale.languageCode == 'ru',
                            onTap: () {
                              context.read<SettingsBloc>().add(
                                const LanguageChanged(Locale('ru')),
                              );
                            },
                          ),
                          const Gap(12),
                          _languageCard(
                            context,
                            title: 'Uzbek',
                            flag: Assets.icons.icUz,
                            selected: state.locale.languageCode == 'uz',
                            onTap: () {
                              context.read<SettingsBloc>().add(
                                const LanguageChanged(Locale('uz')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const Gap(24),
                    _sectionTitle(context, l10n.offlineDataManager),
                    const Gap(12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _offlineDataCard(context, state),
                    ),
                    const Gap(24),
                    _sectionTitle(context, l10n.general),
                    const Gap(12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          _toggleRowCard(
                            context,
                            icon: Icons.dark_mode_outlined,
                            title: l10n.darkMode,
                            trailing: Switch.adaptive(
                              value: state.themeMode == ThemeMode.dark,
                              onChanged: (value) {
                                context.read<SettingsBloc>().add(
                                  DarkModeToggled(value),
                                );
                              },
                            ),
                          ),
                          const Gap(12),
                          _toggleRowCard(
                            context,
                            icon: Icons.notifications_none_rounded,
                            title: l10n.notifications,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  state.notificationsEnabled
                                      ? l10n.notificationsOn
                                      : l10n.notificationsOff,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const Gap(6),
                                Icon(
                                  Icons.chevron_right,
                                  size: 16,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ],
                            ),
                            onTap: () {
                              context.read<SettingsBloc>().add(
                                NotificationsToggled(
                                  !state.notificationsEnabled,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                    Center(
                      child: Text(
                        l10n.versionBuild(
                          state.appVersion,
                          state.appBuildNumber,
                        ),
                        style: TextStyle(
                          fontSize: 10,
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _statusPill(BuildContext context, SettingsState state) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(maxWidth: 140),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.7),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              state.isOnline ? Icons.check : Icons.wifi_off,
              size: 12,
              color: state.isOnline ? colorScheme.primary : colorScheme.error,
            ),
          ),
          const Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.isOnline ? l10n.online : l10n.offline,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 0.4,
                    fontWeight: FontWeight.w700,
                    color:
                        state.isOnline
                            ? colorScheme.primary.withValues(alpha: 0.85)
                            : colorScheme.error,
                  ),
                ),
                Text(
                  _statusSyncText(context, state),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _languageCard(
    BuildContext context, {
    required String title,
    required SvgGenImage flag,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          decoration: BoxDecoration(
            color:
                selected
                    ? colorScheme.primary.withValues(alpha: 0.1)
                    : colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              width: selected ? 2 : 1,
              color:
                  selected ? colorScheme.primary : colorScheme.outlineVariant,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: flag.svg(
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                ),
              ),
              const Gap(6),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color:
                      selected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _offlineDataCard(BuildContext context, SettingsState state) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final usedText = _formatBytes(state.storageUsedBytes);
    final availableText = _formatBytes(
      (state.storageBudgetBytes - state.storageUsedBytes).clamp(
        0,
        _storageBudgetBytes,
      ),
    );
    final progress =
        state.storageBudgetBytes == 0
            ? 0.0
            : (state.storageUsedBytes / state.storageBudgetBytes).clamp(
              0.0,
              1.0,
            );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.65),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.storage_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.localStorage,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      l10n.manageOfflineMaps,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed:
                    state.isLoading
                        ? null
                        : () {
                          context.read<SettingsBloc>().add(
                            const CleanUpPressed(),
                          );
                        },
                style: TextButton.styleFrom(
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                  foregroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                ),
                child: Text(
                  l10n.cleanUp,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const Gap(20),
          Row(
            children: [
              Text(
                l10n.usedStorage(usedText),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                l10n.availableStorage(availableText),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Gap(8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: progress,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(colorScheme.primary),
            ),
          ),
          const Gap(4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${state.storageEntryCount} entries',
              style: TextStyle(
                fontSize: 10,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Gap(16),
          Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
          const Gap(12),
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.6,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Text(
                  l10n.autoSyncWifi,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Switch.adaptive(
                value: state.autoSyncOnWifi,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(AutoSyncToggled(value));
                },
              ),
            ],
          ),
          const Gap(14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed:
                  state.isSyncing
                      ? null
                      : () {
                        context.read<SettingsBloc>().add(
                          const SyncNowPressed(),
                        );
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF111616),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon:
                  state.isSyncing
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : const Icon(Icons.sync, size: 16),
              label: Text(
                l10n.syncNow,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleRowCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final content = Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, size: 18, color: colorScheme.onSurface),
        ),
        const Gap(12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        trailing,
      ],
    );

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.65),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: content,
        ),
      ),
    );
  }

  String _statusSyncText(BuildContext context, SettingsState state) {
    final l10n = AppLocalizations.of(context)!;
    final last = state.lastSyncedAt;
    if (last == null) return l10n.syncedJustNow;

    final diff = DateTime.now().difference(last);
    if (diff.inMinutes < 1) {
      return l10n.syncedJustNow;
    }
    if (diff.inMinutes < 60) {
      return l10n.lastSyncedAt('${diff.inMinutes}m');
    }
    if (diff.inHours < 24) {
      return l10n.lastSyncedAt('${diff.inHours}h');
    }
    return l10n.lastSyncedAt('${diff.inDays}d');
  }

  String _formatBytes(int bytes) {
    if (bytes >= 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
    }
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
    if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)}KB';
    }
    return '${bytes}B';
  }

  String _localizeError(BuildContext context, String message) {
    final l10n = AppLocalizations.of(context)!;
    switch (message) {
      case 'No internet connection. Sync failed.':
        return l10n.syncFailedOffline;
      case 'Some data failed to sync.':
        return l10n.syncPartialFailure;
      case 'Sync failed. Please try again.':
        return l10n.syncFailedGeneric;
      default:
        return message;
    }
  }
}
