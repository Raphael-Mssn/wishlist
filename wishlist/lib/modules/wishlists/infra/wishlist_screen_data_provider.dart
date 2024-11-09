import 'package:async_value_group/async_value_group.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/wishlist_by_id_provider.dart';
import 'package:wishlist/shared/infra/wishs_from_wishlist_provider.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

final wishlistScreenDataProvider =
    Provider.family<AsyncValue<WishlistScreenData>, int>((ref, wishlistId) {
  final wishlist = ref.watch(wishlistByIdProvider(wishlistId));
  final wishs = ref.watch(wishsFromWishlistProvider(wishlistId));

  final wishlistScreenData = AsyncValueGroup.group2(wishlist, wishs);

  return wishlistScreenData;
});

typedef WishlistScreenData = (Wishlist wishlist, IList<Wish> wishs);

extension WishlistScreenDataGetters on WishlistScreenData {
  Wishlist get wishlist => this.$1;
  IList<Wish> get wishs => this.$2;
}
