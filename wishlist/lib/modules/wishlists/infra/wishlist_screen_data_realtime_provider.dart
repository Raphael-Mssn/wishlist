import 'package:async_value_group/async_value_group.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_streams_providers.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_streams_providers.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

final wishlistScreenDataRealtimeProvider =
    Provider.family<AsyncValue<WishlistScreenData>, int>((ref, wishlistId) {
  final wishlist = ref.watch(watchWishlistByIdProvider(wishlistId));
  final wishs = ref.watch(watchWishsFromWishlistProvider(wishlistId));

  final wishlistScreenData = AsyncValueGroup.group2(wishlist, wishs);

  return wishlistScreenData;
});

typedef WishlistScreenData = (Wishlist wishlist, IList<Wish> wishs);

extension WishlistScreenDataGetters on WishlistScreenData {
  Wishlist get wishlist => $1;
  IList<Wish> get wishs => $2;
}
