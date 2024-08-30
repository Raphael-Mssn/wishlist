import 'dart:async';

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

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  AdaptiveTestConfiguration.instance.setDeviceVariants(defaultDeviceConfigs);

  await loadFonts();

  initializeDateFormattingCustom(
    locale: _fakeLocaleSymbols.NAME,
    symbols: _fakeLocaleSymbols,
    patterns: en_USPatterns,
  );

  setupFileComparatorWithThreshold();

  await testMain();
}
