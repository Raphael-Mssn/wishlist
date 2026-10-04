import 'package:adaptive_test/adaptive_test.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_card.dart';
import 'package:wishlist/modules/wishlists/view/wishlist_screen.dart';
import 'package:wishlist/shared/infra/repositories/user_completed_wish/user_completed_wish_repository.dart';
import 'package:wishlist/shared/infra/repositories/user_completed_wish/user_completed_wish_repository_provider.dart';
import 'package:wishlist/shared/models/completed_wish_with_details/completed_wish_with_details.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/navigation/routes.dart';

import '../../../fixtures/fake_data.dart';
import '../../../fixtures/fake_providers.dart';
import '../../../pump_app.dart';

class _MockUserCompletedWishRepository extends Mock
    implements UserCompletedWishRepository {}

void main() {
  CompletedWishWithDetails completedWish(Wish wish, int quantity) {
    return CompletedWishWithDetails(
      wish: wish,
      fromWishlistId: wish.wishlistId,
      fromWishlistName: fakeWishlist1.name,
      ownerPseudo: fakeCurrentUserProfile.pseudo,
      ownerId: fakeCurrentUserId,
      completedAt: fakeNow,
      quantity: quantity,
    );
  }

  Future<void> expectShareButtonVisibility({
    required WidgetTester tester,
    required String testName,
    required int wishlistId,
    required Wishlist wishlist,
    required bool shouldShowShareButton,
  }) async {
    await tester.pumpRouterApp(
      WishlistRoute(wishlistId: wishlistId).location,
      overrides: wishlistScreenOverrides(
        wishlistId: wishlistId,
        wishlist: wishlist,
        wishes: fakeWishes,
        currentUserId: fakeCurrentUserId,
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 1));

    final shareFinder = find.byIcon(Icons.share);
    expect(
      shareFinder,
      shouldShowShareButton ? findsOneWidget : findsNothing,
      reason: testName,
    );
  }

  testAdaptiveWidgets('$WishlistScreen golden test with wishes',
      (tester, variant) async {
    await tester.pumpRouterApp(
      WishlistRoute(wishlistId: 2).location,
      windowConfig: variant,
      overrides: wishlistScreenOverrides(
        wishlistId: 2,
        wishlist: fakeWishlist2,
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
      WishlistRoute(wishlistId: 2).location,
      windowConfig: variant,
      overrides: wishlistScreenOverrides(
        wishlistId: 2,
        wishlist: fakeWishlist2,
        wishes: [],
      ),
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<WishlistScreen>(variant, suffix: 'empty');
  });

  testAdaptiveWidgets('$WishlistScreen golden test with booked wishes',
      (tester, variant) async {
    await tester.pumpRouterApp(
      WishlistRoute(wishlistId: 2).location,
      windowConfig: variant,
      overrides: wishlistScreenOverrides(
        wishlistId: 2,
        wishlist: fakeWishlist2,
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
        WishlistRoute(wishlistId: 2).location,
        overrides: wishlistScreenOverrides(
          wishlistId: 2,
          wishlist: fakeWishlist2,
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

  testWidgets(
    'should not display share button when wishlist is private',
    (tester) async {
      await expectShareButtonVisibility(
        tester: tester,
        testName: 'private wishlist should hide share button',
        wishlistId: 1,
        wishlist: fakeWishlist1,
        shouldShowShareButton: false,
      );
    },
  );

  testWidgets(
    'should display share button when wishlist is public',
    (tester) async {
      await expectShareButtonVisibility(
        tester: tester,
        testName: 'public wishlist should show share button',
        wishlistId: 2,
        wishlist: fakeWishlist2,
        shouldShowShareButton: true,
      );
    },
  );

  testWidgets('hides a fully completed wish and updates the pending count',
      (tester) async {
    await tester.pumpRouterApp(
      WishlistRoute(wishlistId: 1).location,
      overrides: wishlistScreenOverrides(
        wishlistId: 1,
        wishlist: fakeWishlist1,
        wishes: fakeWishes,
        completedWishes: [completedWish(fakeWish1, 1)],
        currentUserId: fakeCurrentUserId,
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text(fakeWish1.name), findsNothing);
    expect(find.text(fakeWish2.name), findsOneWidget);

    final pendingStatsCard = tester.widget<WishlistStatsCard>(
      find.byWidgetPredicate(
        (widget) =>
            widget is WishlistStatsCard &&
            widget.type == WishlistStatsCardType.pending,
      ),
    );
    expect(pendingStatsCard.count, 1);
  });

  testWidgets('hides a fully completed wish from a friend', (tester) async {
    final friendWishlist = Wishlist(
      id: fakeWishlist1.id,
      createdAt: fakeWishlist1.createdAt,
      name: fakeWishlist1.name,
      idOwner: fakeFriendUserId1,
      color: fakeWishlist1.color,
      endDate: fakeWishlist1.endDate,
      canOwnerSeeTakenWish: fakeWishlist1.canOwnerSeeTakenWish,
      order: fakeWishlist1.order,
      updatedBy: fakeWishlist1.updatedBy,
      updatedAt: fakeWishlist1.updatedAt,
    );
    final friendWish = fakeWish1.copyWith(wishlistId: friendWishlist.id);

    await tester.pumpRouterApp(
      WishlistRoute(wishlistId: friendWishlist.id).location,
      overrides: wishlistScreenOverrides(
        wishlistId: friendWishlist.id,
        wishlist: friendWishlist,
        wishes: [friendWish, fakeWish2],
        completedWishes: [completedWish(friendWish, 1)],
        currentUserId: fakeCurrentUserId,
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text(friendWish.name), findsNothing);
    expect(find.text(fakeWish2.name), findsOneWidget);
  });

  testWidgets('displays the remaining quantity for a partially completed wish',
      (tester) async {
    final wishWithQuantity = fakeWish1.copyWith(quantity: 3);

    await tester.pumpRouterApp(
      WishlistRoute(wishlistId: 1).location,
      overrides: wishlistScreenOverrides(
        wishlistId: 1,
        wishlist: fakeWishlist1,
        wishes: [wishWithQuantity],
        completedWishes: [completedWish(wishWithQuantity, 1)],
        currentUserId: fakeCurrentUserId,
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text(wishWithQuantity.name), findsOneWidget);
    expect(find.text('x2'), findsOneWidget);
  });

  testWidgets('adjusts the booked quantity after a partial completion',
      (tester) async {
    final wishWithBookings = fakeWishBooked.copyWith(
      quantity: 4,
      takenByUser: [fakeWishTakenByUser.copyWith(quantity: 3)].toIList(),
    );

    await tester.pumpRouterApp(
      WishlistRoute(wishlistId: 1).location,
      overrides: wishlistScreenOverrides(
        wishlistId: 1,
        wishlist: fakeWishlist1,
        wishes: [wishWithBookings],
        completedWishes: [completedWish(wishWithBookings, 1)],
        currentUserId: fakeCurrentUserId,
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(
      find.byWidgetPredicate(
        (widget) =>
            widget is WishlistStatsCard &&
            widget.type == WishlistStatsCardType.booked,
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text(wishWithBookings.name), findsOneWidget);
    expect(find.text('x2'), findsOneWidget);
  });

  testWidgets('completes the selected wish with its default quantity',
      (tester) async {
    final repository = _MockUserCompletedWishRepository();
    when(
      () => repository.markAsCompleted(
        userId: any(named: 'userId'),
        wishId: any(named: 'wishId'),
        fromWishlistId: any(named: 'fromWishlistId'),
        quantity: any(named: 'quantity'),
      ),
    ).thenAnswer((_) async {});

    await tester.pumpRouterApp(
      WishlistRoute(wishlistId: 1).location,
      overrides: [
        ...wishlistScreenOverrides(
          wishlistId: 1,
          wishlist: fakeWishlist1,
          wishes: fakeWishes,
          currentUserId: fakeCurrentUserId,
        ),
        userCompletedWishRepositoryProvider.overrideWithValue(repository),
      ],
    );

    await tester.pumpAndSettle(const Duration(seconds: 1));
    await tester.longPress(find.text(fakeWish1.name));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.check_circle_outline));
    await tester.pumpAndSettle();

    verify(
      () => repository.markAsCompleted(
        userId: fakeCurrentUserId,
        wishId: fakeWish1.id,
        fromWishlistId: fakeWishlist1.id,
        quantity: 1,
      ),
    ).called(1);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
