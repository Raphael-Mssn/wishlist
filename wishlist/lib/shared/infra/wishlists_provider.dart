import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/non_null_extensions/go_true_client_non_null_getter_user_extension.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';
import 'package:wishlist/shared/infra/wishlist_service.dart';
import 'package:wishlist/shared/models/wishlist/create_request/wishlist_create_request.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

class WishlistsNotifier extends StateNotifier<AsyncValue<List<Wishlist>>> {
  WishlistsNotifier(this._service, String userId)
      : super(const AsyncValue.loading()) {
    loadWishlists(userId);
  }
  final WishlistService _service;

  Future<void> loadWishlists(String userId) async {
    try {
      final wishlists = await _service.getWishlistsByUser(userId);
      state = AsyncValue.data(wishlists.toList());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createWishlist(
    WishlistCreateRequest wishlistCreateRequest,
  ) async {
    try {
      final wishlist = await _service.createWishlist(wishlistCreateRequest);

      state = state.whenData(
        (data) => [
          ...data,
          wishlist,
        ],
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteWishlist(int wishlistId) async {
    try {
      await _service.deleteWishlist(wishlistId);

      state = state.whenData(
        (data) => data.where((wishlist) => wishlist.id != wishlistId).toList(),
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final wishlistsProvider =
    StateNotifierProvider<WishlistsNotifier, AsyncValue<List<Wishlist>>>((ref) {
  final service = ref.read(wishlistServiceProvider);
  final userId = ref.read(supabaseClientProvider).auth.currentUserNonNull.id;
  return WishlistsNotifier(service, userId);
});
