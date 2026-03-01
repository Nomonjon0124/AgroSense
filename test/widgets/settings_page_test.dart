import 'package:agro_sense/core/settings/app_settings_cubit.dart';
import 'package:agro_sense/core/settings/app_settings_repository.dart';
import 'package:agro_sense/features/presentation/pages/settings/settings_part.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestSettingsRepository implements AppSettingsRepository {
  ThemeMode mode = ThemeMode.system;
  Locale locale = const Locale('en');

  @override
  Future<Locale> getLocale() async => locale;

  @override
  Future<ThemeMode> getThemeMode() async => mode;

  @override
  Future<void> setLocale(Locale locale) async {
    this.locale = locale;
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    this.mode = mode;
  }
}

void main() {
  testWidgets('Settings page updates theme and locale', (tester) async {
    final repository = _TestSettingsRepository();
    final cubit = AppSettingsCubit(repository: repository);
    await cubit.initialize();

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: BlocProvider.value(value: cubit, child: const SettingsPage()),
      ),
    );

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(cubit.state.themeMode, ThemeMode.dark);

    await tester.tap(find.text('RU'));
    await tester.pumpAndSettle();
    expect(cubit.state.locale.languageCode, 'ru');
  });
}
