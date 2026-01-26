import 'package:adaptive_test/adaptive_test.dart';
import 'package:wishlist/modules/friends/view/screens/friend_details_screen.dart';
import 'package:wishlist/shared/navigation/routes.dart';

import '../../../fixtures/fake_data.dart';
import '../../../fixtures/fake_providers.dart';
import '../../../pump_app.dart';

void main() {
  testAdaptiveWidgets('$FriendDetailsScreen golden test',
      (tester, variant) async {
    await tester.pumpRouterApp(
      FriendDetailsRoute(fakeFriendUserId1).location,
      windowConfig: variant,
      overrides: friendDetailsScreenOverrides(friendId: fakeFriendUserId1),
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<FriendDetailsScreen>(variant);
  });

  testAdaptiveWidgets('$FriendDetailsScreen when empty',
      (tester, variant) async {
    await tester.pumpRouterApp(
      FriendDetailsRoute(fakeFriendUserId1).location,
      windowConfig: variant,
      overrides: friendDetailsScreenOverrides(
        friendId: fakeFriendUserId1,
        friendDetails: fakeFriendDetailsEmpty,
      ),
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<FriendDetailsScreen>(variant, suffix: 'empty');
  });
}
