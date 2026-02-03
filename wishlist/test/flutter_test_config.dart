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
/// En CI (Linux), le rendu peut différer légèrement de macOS.
double get _goldenThreshold {
  final isCI = Platform.environment['CI'] == 'true';
  return isCI ? 0.05 : 0.005; // 5% en CI, 0.5% en local
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
