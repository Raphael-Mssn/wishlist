import 'package:adaptive_test/adaptive_test.dart';
import 'package:wishlist/modules/home/view/home_screen.dart';
import 'package:wishlist/shared/navigation/floating_nav_bar_navigator.dart';

import '../../../fixtures/fake_providers.dart';
import '../../../pump_app.dart';

void main() {
  testAdaptiveWidgets('$HomeScreen golden test', (tester, variant) async {
    await tester.pumpApp(
      // We pump FloatingNavBarNavigator instead of HomeScreen directly
      // to have the same layout as in the app with the floating navigation bar
      const FloatingNavBarNavigator(
        // ignore: avoid_redundant_argument_values
        currentTab: FloatingNavBarTab.home,
      ),
      windowConfig: variant,
      overrides: homeScreenOverrides(),
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<HomeScreen>(variant);
  });

  testAdaptiveWidgets('$HomeScreen when empty', (tester, variant) async {
    await tester.pumpApp(
      const FloatingNavBarNavigator(
        // ignore: avoid_redundant_argument_values
        currentTab: FloatingNavBarTab.home,
      ),
      windowConfig: variant,
      overrides: homeScreenOverrides(wishlists: []),
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<HomeScreen>(variant, suffix: 'empty');
  });
}
