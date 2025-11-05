import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_community_mutation/riverpod_community_mutation.dart';
import 'package:wishlist/shared/infra/wish_service.dart';
import 'package:wishlist/shared/models/wish/create_request/wish_create_request.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

part 'wish_mutations_provider.g.dart';

@riverpod
class WishMutations extends _$WishMutations with Mutation<void> {
  @override
  AsyncUpdate<void> build() {
    return const AsyncUpdate.idle();
  }

  Future<void> create(WishCreateRequest request) async {
    await mutate(
      () async {
        final service = ref.read(wishServiceProvider);
        await service.createWish(request);
      },
    );
  }

  Future<void> update(Wish wish) async {
    await mutate(
      () async {
        final service = ref.read(wishServiceProvider);
        await service.updateWish(wish);
      },
    );
  }

  Future<void> delete(int wishId) async {
    await mutate(
      () async {
        final service = ref.read(wishServiceProvider);
        await service.deleteWish(wishId);
      },
    );
  }
}
