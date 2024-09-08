import 'package:wishlist/shared/models/wishlist/create_request/wishlist_create_request.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

abstract class WishlistRepository {
  Future<void> createWishlist(WishlistCreateRequest wishlist);

  Future<List<Wishlist>> getWishlistsByUser(String userId);

  Future<void> updateWishlistsOrder(List<Wishlist> wishlists);
}
