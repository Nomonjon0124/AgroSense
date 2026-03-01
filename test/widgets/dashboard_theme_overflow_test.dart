import 'package:agro_sense/features/presentation/pages/dashboard/widgets/dashboard_header.dart';
import 'package:agro_sense/features/presentation/pages/dashboard/widgets/field_status_section.dart';
import 'package:agro_sense/features/presentation/pages/dashboard/widgets/weather_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Dashboard widgets avoid overflow in locales and themes', (
    tester,
  ) async {
    final errors = <FlutterErrorDetails>[];
    final oldHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      errors.add(details);
    };

    for (final locale in const [Locale('en'), Locale('ru'), Locale('uz')]) {
      for (final mode in const [ThemeMode.light, ThemeMode.dark]) {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            themeMode: mode,
            theme: ThemeData.light(useMaterial3: true),
            darkTheme: ThemeData.dark(useMaterial3: true),
            home: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: const [
                      SizedBox(
                        width: 320,
                        child: DashboardHeader(
                          greeting: 'greeting.afternoon',
                          location:
                              'Very Long Farm Address With District Name And Region',
                          isOffline: true,
                          lastSyncTime: '10:00',
                        ),
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        width: 320,
                        child: WeatherCard(
                          temperature: 28,
                          weatherCode: 3,
                          humidity: 88,
                          windSpeed: 22,
                          precipitation: 40,
                          isLiveData: true,
                        ),
                      ),
                      SizedBox(height: 12),
                      SizedBox(width: 320, child: FieldStatusSection()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
      }
    }

    FlutterError.onError = oldHandler;
    final overflow = errors.where(
      (e) => e.exceptionAsString().contains('A RenderFlex overflowed'),
    );
    expect(overflow, isEmpty);
  });
}
