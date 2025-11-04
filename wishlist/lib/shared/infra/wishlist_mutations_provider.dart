import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_community_mutation/riverpod_community_mutation.dart';
import 'package:wishlist/shared/infra/wishlist_service.dart';
import 'package:wishlist/shared/models/wishlist/create_request/wishlist_create_request.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

part 'wishlist_mutations_provider.g.dart';

@riverpod
class CreateWishlistMutation extends _$CreateWishlistMutation
    with Mutation<Wishlist> {
  @override
  AsyncUpdate<Wishlist> build() {
    return const AsyncUpdate.idle();
  }

  Future<Wishlist?> createWishlist(WishlistCreateRequest request) async {
    await mutate(
      () async {
        final service = ref.read(wishlistServiceProvider);
        return service.createWishlist(request);
      },
    );

    return state.value;
  }
}

@riverpod
class UpdateWishlistMutation extends _$UpdateWishlistMutation
    with Mutation<Wishlist> {
  @override
  AsyncUpdate<Wishlist> build() {
    return const AsyncUpdate.idle();
  }

  Future<Wishlist?> updateWishlist(Wishlist wishlist) async {
    await mutate(
      () async {
        final service = ref.read(wishlistServiceProvider);
        return service.updateWishlist(wishlist);
      },
    );

    return state.value;
  }
}

@riverpod
class DeleteWishlistMutation extends _$DeleteWishlistMutation
    with Mutation<void> {
  @override
  AsyncUpdate<void> build() {
    return const AsyncUpdate.idle();
  }

  Future<void> deleteWishlist(int wishlistId, String userId) async {
    await mutate(
      () async {
        final service = ref.read(wishlistServiceProvider);
        await service.deleteWishlist(wishlistId);
      },
    );
  }
}
