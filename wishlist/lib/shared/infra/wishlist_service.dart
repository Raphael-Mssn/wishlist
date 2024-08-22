import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_repository.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_repository_provider.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

class WishlistService {
  WishlistService(this._wishlistRepository);
  final WishlistRepository _wishlistRepository;

  Future<void> createWishlist(Wishlist wishlist) async {
    return _wishlistRepository.createWishlist(wishlist);
  }
}

final wishlistServiceProvider =
    Provider((ref) => WishlistService(ref.watch(wishlistRepositoryProvider)));
