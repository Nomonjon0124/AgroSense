part of 'settings_bloc.dart';

@immutable
class SettingsState {
  final bool isLoading;
  final bool isSyncing;
  final bool isOnline;
  final bool notificationsEnabled;
  final bool autoSyncOnWifi;
  final DateTime? lastSyncedAt;
  final int storageUsedBytes;
  final int storageBudgetBytes;
  final int storageEntryCount;
  final String? errorMessage;
  final ThemeMode themeMode;
  final Locale locale;
  final String appVersion;
  final String appBuildNumber;
  final DateTime? lastMapSyncAt;

  const SettingsState({
    required this.isLoading,
    required this.isSyncing,
    required this.isOnline,
    required this.notificationsEnabled,
    required this.autoSyncOnWifi,
    required this.lastSyncedAt,
    required this.storageUsedBytes,
    required this.storageBudgetBytes,
    required this.storageEntryCount,
    required this.errorMessage,
    required this.themeMode,
    required this.locale,
    required this.appVersion,
    required this.appBuildNumber,
    required this.lastMapSyncAt,
  });

  factory SettingsState.initial() {
    return const SettingsState(
      isLoading: true,
      isSyncing: false,
      isOnline: false,
      notificationsEnabled: true,
      autoSyncOnWifi: true,
      lastSyncedAt: null,
      storageUsedBytes: 0,
      storageBudgetBytes: StorageStatsService.defaultBudgetBytes,
      storageEntryCount: 0,
      errorMessage: null,
      themeMode: ThemeMode.light,
      locale: Locale('uz'),
      appVersion: '--',
      appBuildNumber: '--',
      lastMapSyncAt: null,
    );
  }

  SettingsState copyWith({
    bool? isLoading,
    bool? isSyncing,
    bool? isOnline,
    bool? notificationsEnabled,
    bool? autoSyncOnWifi,
    DateTime? lastSyncedAt,
    bool clearLastSyncedAt = false,
    int? storageUsedBytes,
    int? storageBudgetBytes,
    int? storageEntryCount,
    String? errorMessage,
    bool clearErrorMessage = false,
    ThemeMode? themeMode,
    Locale? locale,
    String? appVersion,
    String? appBuildNumber,
    DateTime? lastMapSyncAt,
    bool clearLastMapSyncAt = false,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      isSyncing: isSyncing ?? this.isSyncing,
      isOnline: isOnline ?? this.isOnline,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      autoSyncOnWifi: autoSyncOnWifi ?? this.autoSyncOnWifi,
      lastSyncedAt:
          clearLastSyncedAt ? null : (lastSyncedAt ?? this.lastSyncedAt),
      storageUsedBytes: storageUsedBytes ?? this.storageUsedBytes,
      storageBudgetBytes: storageBudgetBytes ?? this.storageBudgetBytes,
      storageEntryCount: storageEntryCount ?? this.storageEntryCount,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      appVersion: appVersion ?? this.appVersion,
      appBuildNumber: appBuildNumber ?? this.appBuildNumber,
      lastMapSyncAt:
          clearLastMapSyncAt ? null : (lastMapSyncAt ?? this.lastMapSyncAt),
    );
  }
}
