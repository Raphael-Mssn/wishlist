import 'package:adaptive_test/adaptive_test.dart';
import 'package:wishlist/modules/auth/view/reset_password_screen.dart';
import 'package:wishlist/shared/navigation/routes.dart';

import '../../../pump_app.dart';

void main() {
  testAdaptiveWidgets('$ResetPasswordScreen golden test',
      (tester, variant) async {
    await tester.pumpRouterApp(
      ResetPasswordRoute().location,
      windowConfig: variant,
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<ResetPasswordScreen>(variant);
  });
}
