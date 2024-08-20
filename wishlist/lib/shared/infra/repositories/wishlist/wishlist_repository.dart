import 'package:wishlist/shared/models/wishlist/wishlist.dart';

abstract class WishlistRepository {
  Future<void> createWishlist(Wishlist wishlist);
}
