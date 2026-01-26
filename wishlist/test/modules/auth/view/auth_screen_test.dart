import 'package:adaptive_test/adaptive_test.dart';
import 'package:wishlist/modules/auth/view/auth_screen.dart';
import 'package:wishlist/shared/navigation/routes.dart';

import '../../../pump_app.dart';

void main() {
  testAdaptiveWidgets('$AuthScreen golden test', (tester, variant) async {
    await tester.pumpRouterApp(
      AuthRoute().location,
      windowConfig: variant,
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<AuthScreen>(variant);
  });
}
