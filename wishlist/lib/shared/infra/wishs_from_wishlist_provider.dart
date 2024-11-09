import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/wish_service.dart';
import 'package:wishlist/shared/models/wish/create_request/wish_create_request.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

class WishsFromWishlistNotifier extends StateNotifier<AsyncValue<IList<Wish>>> {
  WishsFromWishlistNotifier(this._service, this.wishlistId)
      : super(const AsyncValue.loading()) {
    loadWishs();
  }

  final WishService _service;
  final int wishlistId;

  Future<void> loadWishs() async {
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
    Wish wishToUpdate,
  ) async {
    try {
      final updatedWish = await _service.updateWish(wishToUpdate);

      state = state.whenData(
        (data) =>
            data.map((e) => e.id == updatedWish.id ? updatedWish : e).toIList(),
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteWish(int wishId) async {
    try {
      await _service.deleteWish(wishId);

      state = state.whenData(
        (data) => data.where((e) => e.id != wishId).toIList(),
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
