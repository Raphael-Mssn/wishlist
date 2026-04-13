import 'dart:async';
import 'dart:io';

import 'package:adaptive_test/adaptive_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_custom.dart';
import 'package:intl/date_symbols.dart';

final defaultDeviceConfigs = {
  iPhone8,
  iPhone13,
  pixel5,
};

final _fakeLocaleSymbols = en_USSymbols;

/// Seuil de tolérance pour les golden tests.
/// Les goldens sont générés en CI (Linux) — seule source de vérité.
/// En CI le seuil est strict (même environnement), en local il est
/// plus tolérant pour absorber les différences de rendu macOS/Windows.
double get _goldenThreshold {
  final isCI = Platform.environment['CI'] == 'true';
  return isCI ? 0.005 : 0.05;
}

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  AdaptiveTestConfiguration.instance.setDeviceVariants(defaultDeviceConfigs);

  await loadFonts();

  initializeDateFormattingCustom(
    locale: _fakeLocaleSymbols.NAME,
    symbols: _fakeLocaleSymbols,
    patterns: en_USPatterns,
  );

  setupFileComparatorWithThreshold(_goldenThreshold);

  await testMain();
}
