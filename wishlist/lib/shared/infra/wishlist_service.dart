import 'dart:math';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_repository.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_repository_provider.dart';
import 'package:wishlist/shared/models/wishlist/create_request/wishlist_create_request.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

class WishlistService {
  WishlistService(this._wishlistRepository);
  final WishlistRepository _wishlistRepository;

  Future<Wishlist> createWishlist(WishlistCreateRequest wishlist) async {
    return _wishlistRepository.createWishlist(wishlist);
  }

  Future<IList<Wishlist>> getWishlistsByUser(String userId) async {
    return _wishlistRepository.getWishlistsByUser(userId);
  }

  Future<void> updateWishlistsOrder(IList<Wishlist> wishlists) async {
    return _wishlistRepository.updateWishlistsOrder(wishlists);
  }

  Future<int> getNextWishlistOrderByUser(String userId) async {
    final wishlists = await getWishlistsByUser(userId);
    if (wishlists.isEmpty) {
      return 0;
    }
    return wishlists.map((wishlist) => wishlist.order).reduce(max) + 1;
  }
}

final wishlistServiceProvider =
    Provider((ref) => WishlistService(ref.watch(wishlistRepositoryProvider)));
