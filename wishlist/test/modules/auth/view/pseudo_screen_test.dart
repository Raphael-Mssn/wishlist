import 'package:adaptive_test/adaptive_test.dart';
import 'package:wishlist/modules/auth/view/pseudo_screen.dart';
import 'package:wishlist/shared/navigation/routes.dart';

import '../../../fixtures/fake_providers.dart';
import '../../../pump_app.dart';

void main() {
  testAdaptiveWidgets('$PseudoScreen golden test', (tester, variant) async {
    await tester.pumpRouterApp(
      PseudoRoute().location,
      windowConfig: variant,
      overrides: pseudoScreenOverrides(),
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<PseudoScreen>(variant);
  });
}
