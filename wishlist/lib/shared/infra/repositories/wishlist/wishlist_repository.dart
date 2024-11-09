import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:wishlist/shared/models/wishlist/create_request/wishlist_create_request.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

abstract class WishlistRepository {
  Future<Wishlist> createWishlist(WishlistCreateRequest wishlist);

  Future<IList<Wishlist>> getWishlistsByUser(String userId);

  Future<IList<Wishlist>> getPublicWishlistsByUser(String userId);

  Future<Wishlist> getWishlistById(int wishlistId);

  Future<void> updateWishlistsOrder(IList<Wishlist> wishlists);

  Future<void> updateWishlistSettings(Wishlist wishlist);

  Future<void> deleteWishlist(int wishlistId);
}
