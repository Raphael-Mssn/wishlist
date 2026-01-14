import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/booked_wishes_realtime_provider.dart';
import 'package:wishlist/shared/infra/friendships_realtime_provider.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';
import 'package:wishlist/shared/infra/wishlists_realtime_provider.dart';
import 'package:wishlist/shared/models/booked_wish_with_details/booked_wish_with_details.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

import 'fake_data.dart';
import 'mock_supabase.dart';

// =============================================================================
// SUPABASE PROVIDER OVERRIDE
// =============================================================================

/// Override pour supabaseClientProvider avec un mock
Override supabaseClientOverride({String? userId}) {
  return supabaseClientProvider.overrideWithValue(
    createMockSupabaseClient(userId: userId),
  );
}

// =============================================================================
// WISHLISTS PROVIDER OVERRIDES
// =============================================================================

/// Override pour wishlistsRealtimeProvider avec des wishlists de test
Override wishlistsRealtimeOverride({
  List<Wishlist>? wishlists,
}) {
  return wishlistsRealtimeProvider.overrideWith(
    (ref) => Stream.value(wishlists ?? fakeWishlists),
  );
}

/// Override pour wishlistsRealtimeProvider avec une liste vide
Override emptyWishlistsRealtimeOverride() {
  return wishlistsRealtimeProvider.overrideWith(
    (ref) => Stream.value(<Wishlist>[]),
  );
}

// =============================================================================
// FRIENDS PROVIDER OVERRIDES
// =============================================================================

/// Override pour friendshipsRealtimeProvider avec des amis de test
Override friendshipsRealtimeOverride({
  FriendsData? friendsData,
}) {
  return friendshipsRealtimeProvider.overrideWith(
    (ref) => Stream.value(friendsData ?? fakeFriendsData),
  );
}

/// Override pour friendshipsRealtimeProvider avec une liste vide
Override emptyFriendshipsRealtimeOverride() {
  return friendshipsRealtimeProvider.overrideWith(
    (ref) => Stream.value(fakeEmptyFriendsData),
  );
}

// =============================================================================
// BOOKED WISHES PROVIDER OVERRIDES
// =============================================================================

/// Override pour bookedWishesRealtimeProvider avec des wishes réservés de test
Override bookedWishesRealtimeOverride({
  IList<BookedWishWithDetails>? bookedWishes,
}) {
  return bookedWishesRealtimeProvider.overrideWith(
    (ref) => Stream.value(bookedWishes ?? fakeBookedWishes),
  );
}

/// Override pour bookedWishesRealtimeProvider avec une liste vide
Override emptyBookedWishesRealtimeOverride() {
  return bookedWishesRealtimeProvider.overrideWith(
    (ref) => Stream.value(fakeEmptyBookedWishes),
  );
}

// =============================================================================
// COMBINED OVERRIDES FOR SCREENS
// =============================================================================

/// Overrides pour le HomeScreen (tab home de FloatingNavBarNavigator)
List<Override> homeScreenOverrides({
  List<Wishlist>? wishlists,
  FriendsData? friendsData,
  IList<BookedWishWithDetails>? bookedWishes,
  String? currentUserId,
}) {
  return [
    supabaseClientOverride(userId: currentUserId),
    wishlistsRealtimeOverride(wishlists: wishlists),
    friendshipsRealtimeOverride(friendsData: friendsData),
    bookedWishesRealtimeOverride(bookedWishes: bookedWishes),
  ];
}

/// Overrides pour tous les écrans avec des données vides
List<Override> emptyDataOverrides({String? currentUserId}) {
  return [
    supabaseClientOverride(userId: currentUserId),
    emptyWishlistsRealtimeOverride(),
    emptyFriendshipsRealtimeOverride(),
    emptyBookedWishesRealtimeOverride(),
  ];
}
