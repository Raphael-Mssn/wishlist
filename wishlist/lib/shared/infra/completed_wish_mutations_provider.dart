import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_community_mutation/riverpod_community_mutation.dart';
import 'package:wishlist/shared/infra/completed_wish_service.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

part 'completed_wish_mutations_provider.g.dart';

@riverpod
class CompletedWishMutations extends _$CompletedWishMutations
    with Mutation<void> {
  @override
  AsyncUpdate<void> build() {
    return const AsyncUpdate.idle();
  }

  Future<void> markAsCompleted(Wish wish) async {
    await mutate(
      () async {
        final service = ref.read(completedWishServiceProvider);
        await service.markAsCompleted(wish);
      },
    );
  }

  Future<void> unmarkAsCompleted(int wishId) async {
    await mutate(
      () async {
        final service = ref.read(completedWishServiceProvider);
        await service.unmarkAsCompleted(wishId);
      },
    );
  }
}
