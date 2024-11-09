import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/wish_service.dart';
import 'package:wishlist/shared/models/wish/create_request/wish_create_request.dart';
import 'package:wishlist/shared/models/wish/update_request/wish_update_request.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

class WishsFromWishlistNotifier extends StateNotifier<AsyncValue<IList<Wish>>> {
  WishsFromWishlistNotifier(this._service, int wishlistId)
      : super(const AsyncValue.loading()) {
    loadWishs(wishlistId);
  }

  final WishService _service;

  Future<void> loadWishs(int wishlistId) async {
    try {
      final wishs = await _service.getWishsFromWishlist(wishlistId);
      state = AsyncValue.data(wishs);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createWish(
    WishCreateRequest wishlistCreateRequest,
  ) async {
    try {
      final wish = await _service.createWish(wishlistCreateRequest);

      state = state.whenData(
        (data) => [
          ...data,
          wish,
        ].toIList(),
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateWish(
    int wishId,
    WishUpdateRequest wishUpdateRequest,
  ) async {
    try {
      final wish = await _service.updateWish(wishId, wishUpdateRequest);

      state = state.whenData(
        (data) => data
            .map(
              (e) => e.id == wishId ? wish : e,
            )
            .toIList(),
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final wishsFromWishlistProvider = StateNotifierProvider.family<
    WishsFromWishlistNotifier, AsyncValue<IList<Wish>>, int>((ref, wishlistId) {
  final service = ref.read(wishServiceProvider);
  return WishsFromWishlistNotifier(service, wishlistId);
});
