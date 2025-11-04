import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_community_mutation/riverpod_community_mutation.dart';
import 'package:wishlist/shared/infra/friendship_service.dart';

part 'friendship_mutations_provider.g.dart';

@riverpod
class FriendshipMutations extends _$FriendshipMutations with Mutation<void> {
  @override
  AsyncUpdate<void> build() {
    return const AsyncUpdate.idle();
  }

  Future<void> askFriendship(String userId) async {
    await mutate(
      () async {
        final service = ref.read(friendshipServiceProvider);
        await service.askFriendshipTo(userId);
      },
    );
  }

  Future<void> cancelFriendshipRequest(String userId) async {
    await mutate(
      () async {
        final service = ref.read(friendshipServiceProvider);
        await service.cancelFriendshipRequest(userId);
      },
    );
  }

  Future<void> acceptFriendship(String userId) async {
    await mutate(
      () async {
        final service = ref.read(friendshipServiceProvider);
        await service.acceptFriendshipWith(userId);
      },
    );
  }

  Future<void> declineFriendship(String userId) async {
    await mutate(
      () async {
        final service = ref.read(friendshipServiceProvider);
        await service.declineFriendshipWith(userId);
      },
    );
  }

  Future<void> removeFriendship(String userId) async {
    await mutate(
      () async {
        final service = ref.read(friendshipServiceProvider);
        await service.removeFriendshipWith(userId);
      },
    );
  }
}
