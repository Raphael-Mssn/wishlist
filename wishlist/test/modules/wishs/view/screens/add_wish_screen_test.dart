import 'package:adaptive_test/adaptive_test.dart';
import 'package:wishlist/modules/wishs/view/screens/add_wish_screen.dart';

import '../../../../fixtures/fake_data.dart';
import '../../../../fixtures/fake_providers.dart';
import '../../../../pump_app.dart';

void main() {
  testAdaptiveWidgets('$AddWishScreen golden test with multiple wishlists',
      (tester, variant) async {
    await tester.pumpApp(
      const AddWishScreen(),
      windowConfig: variant,
      overrides: [
        wishlistsRealtimeOverride(
          wishlists: [fakeWishlist1, fakeWishlist2, fakeWishlist3],
        ),
      ],
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<AddWishScreen>(variant);
  });
}
