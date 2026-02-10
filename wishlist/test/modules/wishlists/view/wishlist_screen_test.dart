import 'package:adaptive_test/adaptive_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_card.dart';
import 'package:wishlist/modules/wishlists/view/wishlist_screen.dart';
import 'package:wishlist/shared/navigation/routes.dart';

import '../../../fixtures/fake_data.dart';
import '../../../fixtures/fake_providers.dart';
import '../../../pump_app.dart';

void main() {
  testAdaptiveWidgets('$WishlistScreen golden test with wishes',
      (tester, variant) async {
    await tester.pumpRouterApp(
      WishlistRoute(wishlistId: 1).location,
      windowConfig: variant,
      overrides: wishlistScreenOverrides(
        wishlistId: 1,
        wishlist: fakeWishlist1,
        wishes: fakeWishes,
      ),
    );

    // Pump suffisamment pour que les animations se terminent
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await tester.expectGolden<WishlistScreen>(variant);
  });

  testAdaptiveWidgets('$WishlistScreen golden test when empty',
      (tester, variant) async {
    await tester.pumpRouterApp(
      WishlistRoute(wishlistId: 1).location,
      windowConfig: variant,
      overrides: wishlistScreenOverrides(
        wishlistId: 1,
        wishlist: fakeWishlist1,
        wishes: [],
      ),
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<WishlistScreen>(variant, suffix: 'empty');
  });

  testAdaptiveWidgets('$WishlistScreen golden test with booked wishes',
      (tester, variant) async {
    await tester.pumpRouterApp(
      WishlistRoute(wishlistId: 1).location,
      windowConfig: variant,
      overrides: wishlistScreenOverrides(
        wishlistId: 1,
        wishlist: fakeWishlist1,
        wishes: fakeWishesWithBooked,
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Tap sur l'onglet "booked" pour naviguer vers la page des réservations
    final bookedCard = find.byWidgetPredicate(
      (widget) =>
          widget is WishlistStatsCard &&
          widget.type == WishlistStatsCardType.booked,
    );

    await tester.tap(bookedCard);

    // Pump suffisamment pour que les animations se terminent
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await tester.expectGolden<WishlistScreen>(variant, suffix: 'booked');
  });

  testWidgets(
    'should only exit selection mode when user does back system action',
    (tester) async {
      await tester.pumpRouterApp(
        WishlistRoute(wishlistId: 1).location,
        overrides: wishlistScreenOverrides(
          wishlistId: 1,
          wishlist: fakeWishlist1,
          wishes: fakeWishes,
          currentUserId: fakeCurrentUserId,
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Long-press sur un wish pour activer le mode sélection
      final wishTile = find.text('iPhone 15 Pro');
      expect(wishTile, findsOneWidget);
      await tester.longPress(wishTile);
      await tester.pumpAndSettle();

      // En mode sélection : affiche Supprimer
      expect(find.byIcon(Icons.delete), findsOneWidget);
      expect(find.byIcon(Icons.add), findsNothing);
      expect(find.byType(WishlistScreen), findsOneWidget);

      // Simuler l'action retour système
      // (déclenche PopScope, pas le bouton AppBar)
      final context = tester.element(find.byType(WishlistScreen));
      await Navigator.of(context).maybePop();
      await tester.pumpAndSettle();

      // On reste sur l'écran et le mode sélection est quitté : affiche Ajouter
      expect(find.byType(WishlistScreen), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsNothing);
    },
  );
}
