import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/friendship/friendship_stream_repository_provider.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/models/app_user.dart';

final friendshipsRealtimeProvider =
    StreamProvider.autoDispose<FriendsData>((ref) {
  final userService = ref.watch(userServiceProvider);
  final friendshipRepo = ref.watch(friendshipStreamRepositoryProvider);

  final allFriendshipsStream = friendshipRepo.watchCurrentUserAllFriendships();

  return allFriendshipsStream.asyncMap((friendshipIds) async {
    final results = await Future.wait([
      _loadUsersFromIds(userService, friendshipIds.friendsIds),
      _loadUsersFromIds(userService, friendshipIds.pendingIds),
      _loadUsersFromIds(userService, friendshipIds.requestedIds),
    ]);

    final friends = results[0];
    final pendingFriends = results[1];
    final requestedFriends = results[2];

    return FriendsData(
      friends: friends,
      pendingFriends: pendingFriends,
      requestedFriends: requestedFriends,
    );
  });
});

Future<IList<AppUser>> _loadUsersFromIds(
  UserService userService,
  ISet<String> userIds,
) async {
  if (userIds.isEmpty) {
    return const IListConst([]);
  }

  try {
    final users = await Future.wait(
      userIds.map((userId) => userService.getAppUserById(userId)),
    );
    return users.toIList();
  } catch (e) {
    return const IListConst([]);
  }
}

class FriendsData {
  const FriendsData({
    required this.friends,
    required this.pendingFriends,
    required this.requestedFriends,
  });

  final IList<AppUser> friends;
  final IList<AppUser> pendingFriends;
  final IList<AppUser> requestedFriends;

  bool get isEmpty =>
      friends.isEmpty && pendingFriends.isEmpty && requestedFriends.isEmpty;

  int get totalCount =>
      friends.length + pendingFriends.length + requestedFriends.length;

  FriendsData copyWith({
    IList<AppUser>? friends,
    IList<AppUser>? pendingFriends,
    IList<AppUser>? requestedFriends,
  }) {
    return FriendsData(
      friends: friends ?? this.friends,
      pendingFriends: pendingFriends ?? this.pendingFriends,
      requestedFriends: requestedFriends ?? this.requestedFriends,
    );
  }
}
