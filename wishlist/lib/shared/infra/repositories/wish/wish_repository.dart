import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:wishlist/shared/models/wish/create_request/wish_create_request.dart';
import 'package:wishlist/shared/models/wish/update_request/wish_update_request.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

abstract class WishRepository {
  Future<IList<Wish>> getWishsFromWishlist(int wishlistId);
  Future<int> getNbWishsByUser(String userId);
  Future<Wish> createWish(WishCreateRequest wishlist);
  Future<Wish> updateWish(int wishId, WishUpdateRequest wish);
  Future<void> deleteWish(int wishId);
}
