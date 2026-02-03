import 'package:adaptive_test/adaptive_test.dart';
import 'package:wishlist/modules/booked_wishes/view/booked_wishes_screen.dart';
import 'package:wishlist/shared/navigation/floating_nav_bar_navigator.dart';

import '../../../fixtures/fake_providers.dart';
import '../../../pump_app.dart';

void main() {
  testAdaptiveWidgets('$BookedWishesScreen golden test',
      (tester, variant) async {
    await tester.pumpApp(
      const FloatingNavBarNavigator(
        currentTab: FloatingNavBarTab.bookedWishes,
      ),
      windowConfig: variant,
      overrides: homeScreenOverrides(),
    );

    // Pump suffisamment pour que les animations de AnimatedListView se terminent
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await tester.expectGolden<BookedWishesScreen>(variant);
  });

  testAdaptiveWidgets('$BookedWishesScreen when there are no booked wishes',
      (tester, variant) async {
    await tester.pumpApp(
      const FloatingNavBarNavigator(
        currentTab: FloatingNavBarTab.bookedWishes,
      ),
      windowConfig: variant,
      overrides: emptyDataOverrides(),
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<BookedWishesScreen>(variant, suffix: 'empty');
  });
}
