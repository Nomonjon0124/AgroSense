import 'package:agro_sense/features/presentation/pages/alerts/alerts_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Alerts filter switches visible cards', (tester) async {
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
        home: const AlertsPage(),
      ),
    );

    expect(find.text('Frost Warning'), findsOneWidget);
    expect(find.text('Heavy Rain'), findsOneWidget);

    await tester.tap(find.text('Warning'));
    await tester.pumpAndSettle();

    expect(find.text('Frost Warning'), findsNothing);
    expect(find.text('Heavy Rain'), findsOneWidget);
  });
}
