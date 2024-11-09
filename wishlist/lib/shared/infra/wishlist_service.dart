import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_repository.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_repository_provider.dart';
import 'package:wishlist/shared/infra/utils/update_entity.dart';
import 'package:wishlist/shared/infra/wishlist_by_id_provider.dart';
import 'package:wishlist/shared/models/wishlist/create_request/wishlist_create_request.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

class WishlistService {
  WishlistService(this._wishlistRepository, this.ref);
  final WishlistRepository _wishlistRepository;
  final Ref ref;

  Future<Wishlist> createWishlist(WishlistCreateRequest wishlist) async {
    return _wishlistRepository.createWishlist(wishlist);
  }

  Future<IList<Wishlist>> getWishlistsByUser(String userId) async {
    return _wishlistRepository.getWishlistsByUser(userId);
  }

  Future<IList<Wishlist>> getPublicWishlistsByUser(String userId) async {
    return _wishlistRepository.getPublicWishlistsByUser(userId);
  }

  Future<int> getNbWishlistsByUser(String userId) async {
    return _wishlistRepository.getNbWishlistsByUser(userId);
  }

  Future<Wishlist> getWishlistById(int wishlistId) async {
    return _wishlistRepository.getWishlistById(wishlistId);
  }

  Future<Wishlist> updateWishlist(Wishlist wishlist) async {
    final wishlistUpdated = await updateEntity(
      wishlist,
      ref,
      _wishlistRepository.updateWishlist,
    );
    ref.invalidate(wishlistByIdProvider(wishlist.id));

    return wishlistUpdated;
  }

  Future<void> updateWishlistsOrder(IList<Wishlist> wishlists) async {
    for (final wishlist in wishlists) {
      final wishlistUpdated =
          wishlist.copyWith(order: wishlists.indexOf(wishlist));
      await updateWishlist(wishlistUpdated);
    }
  }

  Future<int> getNextWishlistOrderByUser(String userId) async {
    final wishlists = await getWishlistsByUser(userId);
    if (wishlists.isEmpty) {
      return 0;
    }
    return wishlists.map((wishlist) => wishlist.order).reduce(max) + 1;
  }

  Future<void> deleteWishlist(int wishlistId) async {
    await _wishlistRepository.deleteWishlist(wishlistId);
  }
}

final wishlistServiceProvider = Provider(
  (ref) => WishlistService(ref.watch(wishlistRepositoryProvider), ref),
);
