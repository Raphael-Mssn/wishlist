import 'package:adaptive_test/adaptive_test.dart';
import 'package:wishlist/modules/auth/view/forgot_password_screen.dart';
import 'package:wishlist/shared/navigation/routes.dart';

import '../../../pump_app.dart';

void main() {
  testAdaptiveWidgets('$ForgotPasswordScreen golden test',
      (tester, variant) async {
    await tester.pumpRouterApp(
      ForgotPasswordRoute().location,
      windowConfig: variant,
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<ForgotPasswordScreen>(variant);
  });
}
