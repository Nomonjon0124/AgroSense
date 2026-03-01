import 'package:agro_sense/features/presentation/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('BottomNav avoids overflow on narrow width', (tester) async {
    final errors = <FlutterErrorDetails>[];
    final oldHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      errors.add(details);
    };

    final router = GoRouter(
      initialLocation: '/dashboard',
      routes: [
        GoRoute(
          path: '/dashboard',
          builder:
              (context, state) => const Scaffold(
                body: SizedBox.shrink(),
                bottomNavigationBar: BottomNavBar(),
              ),
        ),
        GoRoute(
          path: '/map',
          builder:
              (context, state) => const Scaffold(
                body: SizedBox.shrink(),
                bottomNavigationBar: BottomNavBar(),
              ),
        ),
        GoRoute(
          path: '/alerts',
          builder:
              (context, state) => const Scaffold(
                body: SizedBox.shrink(),
                bottomNavigationBar: BottomNavBar(),
              ),
        ),
        GoRoute(
          path: '/settings',
          builder:
              (context, state) => const Scaffold(
                body: SizedBox.shrink(),
                bottomNavigationBar: BottomNavBar(),
              ),
        ),
      ],
    );

    for (final locale in const [Locale('en'), Locale('ru'), Locale('uz')]) {
      await tester.binding.setSurfaceSize(const Size(320, 690));
      await tester.pumpWidget(
        MaterialApp.router(
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();
    }

    await tester.binding.setSurfaceSize(null);
    FlutterError.onError = oldHandler;
    final overflow = errors.where(
      (e) => e.exceptionAsString().contains('A RenderFlex overflowed'),
    );
    expect(overflow, isEmpty);
  });
}
