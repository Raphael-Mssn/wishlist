import 'package:async_value_group/async_value_group.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/completed_wishes_realtime_provider.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_streams_providers.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_streams_providers.dart';
import 'package:wishlist/shared/models/completed_wish_with_details/completed_wish_with_details.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

final wishlistScreenDataRealtimeProvider =
    Provider.family<AsyncValue<WishlistScreenData>, int>((ref, wishlistId) {
  final wishlistAsync = ref.watch(watchWishlistByIdProvider(wishlistId));
  final wishs = ref.watch(watchWishsFromWishlistProvider(wishlistId));
  final wishlist = wishlistAsync.valueOrNull;

  // Une wishlist supprimée ou archivée est gérée par WishlistScreen
  if (wishlist == null) {
    return switch (wishlistAsync) {
      AsyncError(:final error, :final stackTrace) =>
        AsyncError(error, stackTrace),
      _ => const AsyncLoading(),
    };
  }

  final completedWishes =
      ref.watch(completedWishesByUserRealtimeProvider(wishlist.idOwner));

  return AsyncValueGroup.group3(
    wishlistAsync.whenData((_) => wishlist),
    wishs,
    completedWishes,
  );
});

typedef WishlistScreenData = (
  Wishlist wishlist,
  IList<Wish> wishs,
  IList<CompletedWishWithDetails> completedWishes,
);

extension WishlistScreenDataGetters on WishlistScreenData {
  Wishlist get wishlist => $1;
  IList<Wish> get wishs => $2;
  IList<CompletedWishWithDetails> get completedWishes => $3;
}
