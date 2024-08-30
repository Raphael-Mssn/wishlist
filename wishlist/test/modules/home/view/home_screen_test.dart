import 'package:adaptive_test/adaptive_test.dart';
import 'package:wishlist/modules/home/view/home_screen.dart';
import 'package:wishlist/shared/navigation/floating_nav_bar_navigator.dart';
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
    );

    await tester.expectGolden<HomeScreen>(variant);
  });
}
