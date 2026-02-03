import 'package:adaptive_test/adaptive_test.dart';
import 'package:wishlist/modules/wishs/view/screens/edit_wish_screen.dart';

import '../../../fixtures/fake_data.dart';
import '../../../fixtures/fake_providers.dart';
import '../../../pump_app.dart';

void main() {
  testAdaptiveWidgets('$EditWishScreen golden test', (tester, variant) async {
    await tester.pumpApp(
      const EditWishScreen(wishId: 1),
      windowConfig: variant,
      overrides: wishScreenOverrides(
        wishId: 1,
        wishlistId: 1,
        wish: fakeWish1,
        wishlist: fakeWishlist1,
      ),
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<EditWishScreen>(variant);
  });
}
