import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_community_mutation/riverpod_community_mutation.dart';
import 'package:wishlist/shared/infra/wish_service.dart';
import 'package:wishlist/shared/models/wish/create_request/wish_create_request.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

part 'wish_mutations_provider.g.dart';

@riverpod
class CreateWishMutation extends _$CreateWishMutation with Mutation<Wish> {
  @override
  AsyncUpdate<Wish> build() {
    return const AsyncUpdate.idle();
  }

  Future<Wish?> createWish(WishCreateRequest request) async {
    await mutate(
      () async {
        final service = ref.read(wishServiceProvider);
        return service.createWish(request);
      },
    );

    return state.value;
  }
}

@riverpod
class UpdateWishMutation extends _$UpdateWishMutation with Mutation<Wish> {
  @override
  AsyncUpdate<Wish> build() {
    return const AsyncUpdate.idle();
  }

  Future<Wish?> updateWish(Wish wish) async {
    await mutate(
      () async {
        final service = ref.read(wishServiceProvider);
        return service.updateWish(wish);
      },
    );

    return state.value;
  }
}

@riverpod
class DeleteWishMutation extends _$DeleteWishMutation with Mutation<void> {
  @override
  AsyncUpdate<void> build() {
    return const AsyncUpdate.idle();
  }

  Future<void> deleteWish(int wishId, int wishlistId) async {
    await mutate(
      () async {
        final service = ref.read(wishServiceProvider);
        await service.deleteWish(wishId);
      },
    );
  }
}
