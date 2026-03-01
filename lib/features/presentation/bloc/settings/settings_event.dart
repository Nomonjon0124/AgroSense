part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {
  const SettingsEvent();
}

final class SettingsStarted extends SettingsEvent {
  const SettingsStarted();
}

final class NotificationsToggled extends SettingsEvent {
  final bool enabled;

  const NotificationsToggled(this.enabled);
}

final class AutoSyncToggled extends SettingsEvent {
  final bool enabled;

  const AutoSyncToggled(this.enabled);
}

final class DarkModeToggled extends SettingsEvent {
  final bool isDark;

  const DarkModeToggled(this.isDark);
}

final class LanguageChanged extends SettingsEvent {
  final Locale locale;

  const LanguageChanged(this.locale);
}

final class CleanUpPressed extends SettingsEvent {
  const CleanUpPressed();
}

final class SyncNowPressed extends SettingsEvent {
  const SyncNowPressed();
}

final class ErrorShown extends SettingsEvent {
  const ErrorShown();
}

final class ConnectivityChanged extends SettingsEvent {
  final bool isOnline;

  const ConnectivityChanged(this.isOnline);
}
