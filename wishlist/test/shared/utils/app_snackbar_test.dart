import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishlist/l10n/arb/app_localizations_fr.dart';
import 'package:wishlist/shared/infra/app_exception.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';

import '../../pump_app.dart';

void main() {
  group('showGenericError with AppUserMessageKey.inputTooLong', () {
    testWidgets(
        'should display input too long message when error has userMessageKey '
        'inputTooLong', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                showGenericError(
                  context,
                  error: AppException(
                    statusCode: 400,
                    message: 'db constraint',
                    userMessageKey: AppUserMessageKey.inputTooLong,
                  ),
                );
              },
              child: const Text('Trigger error'),
            );
          },
        ),
      );

      final l10n = AppLocalizationsFr();

      await tester.tap(find.text('Trigger error'));
      await tester.pump(); // run addPostFrameCallback
      await tester.pump(const Duration(milliseconds: 100)); // build overlay

      expect(find.text(l10n.inputTooLong), findsOneWidget);
    });

    testWidgets(
        'should display generic error message when error has no userMessageKey',
        (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                showGenericError(
                  context,
                  error: AppException(
                    statusCode: 500,
                    message: 'Server error',
                  ),
                );
              },
              child: const Text('Trigger error'),
            );
          },
        ),
      );

      final l10n = AppLocalizationsFr();

      await tester.tap(find.text('Trigger error'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.text(l10n.genericError),
        findsOneWidget,
      );
    });
  });
}
