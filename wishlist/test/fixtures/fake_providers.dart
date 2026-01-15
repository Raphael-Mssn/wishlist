import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/app_info_provider.dart';
import 'package:wishlist/shared/infra/booked_wishes_realtime_provider.dart';
import 'package:wishlist/shared/infra/friendships_realtime_provider.dart';
import 'package:wishlist/shared/infra/repositories/user/user_streams_providers.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_streams_providers.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_streams_providers.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/infra/wishlists_realtime_provider.dart';
import 'package:wishlist/shared/models/booked_wish_with_details/booked_wish_with_details.dart';
import 'package:wishlist/shared/models/profile.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
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
// USER SERVICE OVERRIDE
// =============================================================================

/// Override pour userServiceProvider avec un mock
Override userServiceOverride({String? userId, String? userEmail}) {
  return userServiceProvider.overrideWithValue(
    createMockUserService(userId: userId, userEmail: userEmail),
  );
}

// =============================================================================
// PROFILE STREAM OVERRIDE
// =============================================================================

/// Override pour watchCurrentUserProfileProvider avec un profil de test
Override watchCurrentUserProfileOverride({Profile? profile}) {
  return watchCurrentUserProfileProvider.overrideWith(
    (ref) => Stream.value(profile ?? fakeCurrentUserProfile),
  );
}

// =============================================================================
// APP INFO OVERRIDE
// =============================================================================

/// Override pour appInfoProvider avec des infos de test
Override appInfoOverride() {
  return appInfoProvider.overrideWith((ref) async => fakePackageInfo);
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

/// Overrides pour le SettingsScreen
List<Override> settingsScreenOverrides({
  String? currentUserId,
  String? currentUserEmail,
  Profile? currentUserProfile,
}) {
  return [
    supabaseClientOverride(userId: currentUserId),
    userServiceOverride(userId: currentUserId, userEmail: currentUserEmail),
    watchCurrentUserProfileOverride(profile: currentUserProfile),
    appInfoOverride(),
  ];
}

// =============================================================================
// WISHLIST SCREEN OVERRIDES
// =============================================================================

/// Override pour watchWishlistByIdProvider
Override watchWishlistByIdOverride(int wishlistId, {Wishlist? wishlist}) {
  return watchWishlistByIdProvider(wishlistId).overrideWith(
    (ref) => Stream.value(wishlist ?? fakeWishlist1),
  );
}

/// Override pour watchWishsFromWishlistProvider
Override watchWishsFromWishlistOverride(
  int wishlistId, {
  List<Wish>? wishes,
}) {
  return watchWishsFromWishlistProvider(wishlistId).overrideWith(
    (ref) => Stream.value((wishes ?? fakeWishes).toIList()),
  );
}

/// Overrides pour le WishlistScreen
List<Override> wishlistScreenOverrides({
  required int wishlistId,
  Wishlist? wishlist,
  List<Wish>? wishes,
  String? currentUserId,
}) {
  return [
    supabaseClientOverride(userId: currentUserId),
    userServiceOverride(userId: currentUserId),
    watchWishlistByIdOverride(wishlistId, wishlist: wishlist),
    watchWishsFromWishlistOverride(wishlistId, wishes: wishes),
  ];
}
