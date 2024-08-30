import 'package:adaptive_test/adaptive_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/theme/theme.dart';

extension EnhancedWidgetTester on WidgetTester {
  Widget _addReusableWrapper(
    Widget child, {
    required WindowConfigData? windowConfig,
    List<Override>? overrides,
  }) {
    Widget app = ProviderScope(
      // Overrides the autoCloseDurationProvider to disable autoCloseDuration
      // and assert that no timer is pending during tests to avoid errors
      overrides: [
        ...overrides ?? [],
      ],
      child: child,
    );

    if (windowConfig != null) {
      app = AdaptiveWrapper(
        windowConfig: windowConfig,
        tester: this,
        child: app,
      );
    }

    return app;
  }

  List<LocalizationsDelegate<Object?>> get _localizationsDelegates => [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ];

  Locale get _defaultTestLocale => const Locale('fr', 'FR');

  Future<void> pumpApp(
    Widget widget, {
    WindowConfigData? windowConfig,
    List<Override>? overrides,
  }) async {
    final app = _addReusableWrapper(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: _defaultTestLocale,
        localizationsDelegates: _localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: theme,
        builder: (context, child) {
          return Scaffold(
            body: Material(
              color: Colors.transparent,
              child: child,
            ),
          );
        },
        home: widget,
      ),
      windowConfig: windowConfig,
      overrides: overrides,
    );

    return pumpWidget(app);
  }
}
