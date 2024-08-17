import 'package:wishlist/shared/models/wishlist.dart';

abstract class WishlistRepository {
  Future<void> createWishlist(Wishlist wishlist);
}
