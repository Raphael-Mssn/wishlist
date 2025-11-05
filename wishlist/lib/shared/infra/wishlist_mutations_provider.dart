import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_community_mutation/riverpod_community_mutation.dart';
import 'package:wishlist/shared/infra/wishlist_service.dart';
import 'package:wishlist/shared/models/wishlist/create_request/wishlist_create_request.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

part 'wishlist_mutations_provider.g.dart';

@riverpod
class WishlistMutations extends _$WishlistMutations with Mutation<void> {
  @override
  AsyncUpdate<void> build() {
    return const AsyncUpdate.idle();
  }

  Future<void> create(WishlistCreateRequest request) async {
    await mutate(
      () async {
        final service = ref.read(wishlistServiceProvider);
        await service.createWishlist(request);
      },
    );
  }

  Future<void> update(Wishlist wishlist) async {
    await mutate(
      () async {
        final service = ref.read(wishlistServiceProvider);
        await service.updateWishlist(wishlist);
      },
    );
  }

  Future<void> delete(int wishlistId) async {
    await mutate(
      () async {
        final service = ref.read(wishlistServiceProvider);
        await service.deleteWishlist(wishlistId);
      },
    );
  }
}
