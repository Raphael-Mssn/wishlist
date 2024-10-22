import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/friendship_service.dart';
import 'package:wishlist/shared/models/app_user.dart';
import 'package:wishlist/shared/models/friendship/friendship.dart';

class FriendsNotifier extends StateNotifier<AsyncValue<FriendsData>> {
  FriendsNotifier(this._service) : super(const AsyncValue.loading()) {
    loadFriends();
  }
  final FriendshipService _service;

  Future<void> loadFriends() async {
    try {
      final friends = await _service.getCurrentUserFriends();
      final pendingFriends = await _service.getCurrentUserPendingFriends();
      final requestedFriends = await _service.getCurrentUserRequestedFriends();

      state = AsyncValue.data(
        FriendsData(
          friends: friends,
          pendingFriends: pendingFriends,
          requestedFriends: requestedFriends,
        ),
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> acceptFriendRequest(AppUser friend) async {
    try {
      await _service.acceptFriendshipWith(friend.user.id);
      state = state.whenData(
        (data) => data.copyWith(
          requestedFriends: data.requestedFriends.remove(friend),
          friends: data.friends.add(friend),
        ),
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> declineFriendRequest(AppUser friend) async {
    try {
      await _service.declineFriendshipWith(friend.user.id);
      state = state.whenData(
        (data) => data.copyWith(
          requestedFriends: data.requestedFriends.remove(friend),
        ),
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<FriendshipStatus> getFriendshipStatus(String userId) async {
    return _service.currentUserFriendshipStatusWith(userId);
  }

  Future<void> askFriendship(AppUser appUser) async {
    await _service.askFriendshipTo(appUser.user.id);
    state = state.whenData(
      (data) => data.copyWith(
        pendingFriends: data.pendingFriends.add(appUser),
      ),
    );
  }

  Future<void> cancelFriendshipRequest(AppUser appUser) async {
    await _service.cancelFriendshipRequest(appUser.user.id);
    state = state.whenData(
      (data) => data.copyWith(
        pendingFriends: data.pendingFriends.remove(appUser),
      ),
    );
  }

  Future<void> removeFriendshipWith(AppUser appUser) async {
    await _service.removeFriendshipWith(appUser.user.id);
    state = state.whenData(
      (data) => data.copyWith(
        friends: data.friends.remove(appUser),
      ),
    );
  }
}

final friendshipsProvider =
    StateNotifierProvider<FriendsNotifier, AsyncValue<FriendsData>>((ref) {
  final service = ref.read(friendshipServiceProvider);
  return FriendsNotifier(service);
});

class FriendsData {
  const FriendsData({
    required this.friends,
    required this.pendingFriends,
    required this.requestedFriends,
  });
  final ISet<AppUser> friends;
  final ISet<AppUser> pendingFriends;
  final ISet<AppUser> requestedFriends;

  bool get isEmpty =>
      friends.isEmpty && pendingFriends.isEmpty && requestedFriends.isEmpty;

  int get totalCount =>
      friends.length + pendingFriends.length + requestedFriends.length;

  FriendsData copyWith({
    ISet<AppUser>? friends,
    ISet<AppUser>? pendingFriends,
    ISet<AppUser>? requestedFriends,
  }) {
    return FriendsData(
      friends: friends ?? this.friends,
      pendingFriends: pendingFriends ?? this.pendingFriends,
      requestedFriends: requestedFriends ?? this.requestedFriends,
    );
  }
}
