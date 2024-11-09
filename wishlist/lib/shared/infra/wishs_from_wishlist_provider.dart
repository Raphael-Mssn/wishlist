import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/wish_service.dart';
import 'package:wishlist/shared/models/wish/create_request/wish_create_request.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

class WishsFromWishlistNotifier extends StateNotifier<AsyncValue<List<Wish>>> {
  WishsFromWishlistNotifier(this._service, int wishlistId)
      : super(const AsyncValue.loading()) {
    loadWishs(wishlistId);
  }
  final WishService _service;

  Future<void> loadWishs(int wishlistId) async {
    try {
      final wishs = await _service.getWishsFromWishlist(wishlistId);
      state = AsyncValue.data(wishs.toList());
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
        ],
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final wishsFromWishlistProvider = StateNotifierProvider.family<
    WishsFromWishlistNotifier, AsyncValue<List<Wish>>, int>((ref, wishlistId) {
  final service = ref.read(wishServiceProvider);
  return WishsFromWishlistNotifier(service, wishlistId);
});
