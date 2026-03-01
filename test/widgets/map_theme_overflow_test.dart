import 'package:agro_sense/features/map/domain/entities/field_entity.dart';
import 'package:agro_sense/features/presentation/pages/map/map_part.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  testWidgets('Map overlays avoid overflow in locales and themes', (
    tester,
  ) async {
    final errors = <FlutterErrorDetails>[];
    final oldHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      errors.add(details);
    };

    const field = FieldEntity(
      id: '1',
      name: 'Extremely Long Field Name For Localization Stress Test',
      coordinates: [LatLng(41.29, 69.24)],
      areaHectares: 123.45,
      status: FieldStatus.warning,
      currentStage: 'Very Long Crop Stage Name',
      moisture: 22,
      soilTemperature: 19.8,
      healthPercentage: 74,
      cropType: 'Wheat',
    );

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
            theme: ThemeData(useMaterial3: true),
            darkTheme: ThemeData.dark(useMaterial3: true),
            home: Scaffold(
              body: Stack(
                children: [
                  const Positioned(
                    top: 10,
                    left: 10,
                    child: SizedBox(
                      width: 280,
                      child: OfflineStatusBadge(
                        isOnline: false,
                        cachedTimeAgo: '3 hours ago',
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    right: 10,
                    bottom: 10,
                    child: FieldInfoSheet(
                      field: field,
                      onClose: () {},
                      onViewAnalysis: () {},
                    ),
                  ),
                  const LoadingOverlay(
                    progress: 70,
                    message: 'map.loading.loadingFields',
                  ),
                ],
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
