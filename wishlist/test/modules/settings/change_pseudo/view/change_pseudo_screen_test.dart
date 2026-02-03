import 'package:adaptive_test/adaptive_test.dart';
import 'package:wishlist/modules/settings/change_pseudo/view/change_pseudo_screen.dart';

import '../../../../fixtures/fake_providers.dart';
import '../../../../pump_app.dart';

void main() {
  testAdaptiveWidgets('$ChangePseudoScreen golden test',
      (tester, variant) async {
    await tester.pumpApp(
      const ChangePseudoScreen(),
      windowConfig: variant,
      overrides: changePseudoScreenOverrides(),
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<ChangePseudoScreen>(variant);
  });
}
