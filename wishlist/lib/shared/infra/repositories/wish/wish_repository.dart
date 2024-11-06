import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:wishlist/shared/models/wish/create_request/wish_create_request.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

abstract class WishRepository {
  Future<IList<Wish>> getWishsFromWishlist(int wishlistId);
  Future<Wish> createWish(WishCreateRequest wishlist);
}
