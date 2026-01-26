import 'package:adaptive_test/adaptive_test.dart';
import 'package:wishlist/modules/settings/change_password/view/change_password_screen.dart';

import '../../../../pump_app.dart';

void main() {
  testAdaptiveWidgets('$ChangePasswordScreen golden test',
      (tester, variant) async {
    await tester.pumpApp(
      const ChangePasswordScreen(),
      windowConfig: variant,
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<ChangePasswordScreen>(variant);
  });
}
