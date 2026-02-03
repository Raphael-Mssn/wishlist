import 'package:adaptive_test/adaptive_test.dart';
import 'package:wishlist/modules/friends/view/screens/friends_screen.dart';
import 'package:wishlist/shared/navigation/floating_nav_bar_navigator.dart';

import '../../../fixtures/fake_providers.dart';
import '../../../pump_app.dart';

void main() {
  testAdaptiveWidgets('$FriendsScreen golden test', (tester, variant) async {
    await tester.pumpApp(
      const FloatingNavBarNavigator(
        currentTab: FloatingNavBarTab.friends,
      ),
      windowConfig: variant,
      overrides: homeScreenOverrides(),
    );

    // Pump suffisamment pour que les animations se terminent
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await tester.expectGolden<FriendsScreen>(variant);
  });

  testAdaptiveWidgets('$FriendsScreen when empty', (tester, variant) async {
    await tester.pumpApp(
      const FloatingNavBarNavigator(
        currentTab: FloatingNavBarTab.friends,
      ),
      windowConfig: variant,
      overrides: emptyDataOverrides(),
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<FriendsScreen>(variant, suffix: 'empty');
  });
}
