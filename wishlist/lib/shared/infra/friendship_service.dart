import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/friendship/friendship_repository.dart';
import 'package:wishlist/shared/infra/repositories/friendship/friendship_repository_provider.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/infra/wish_service.dart';
import 'package:wishlist/shared/infra/wishlist_service.dart';
import 'package:wishlist/shared/models/app_user.dart';
import 'package:wishlist/shared/models/friend_details/friend_details.dart';
import 'package:wishlist/shared/models/friendship/friendship.dart';

class FriendshipService {
  FriendshipService(this._friendshipRepository, this.ref);
  final FriendshipRepository _friendshipRepository;
  final Ref<Object?> ref;

  Future<ISet<AppUser>> getCurrentUserFriends() async {
    final friendsIds = await _friendshipRepository.getCurrentUserFriendsIds();
    return _getFriendsByFriendsIds(friendsIds);
  }

  Future<ISet<AppUser>> getCurrentUserPendingFriends() async {
    final pendingFriendsIds =
        await _friendshipRepository.getCurrentUserPendingFriendsIds();
    final pendingFriends = await Future.wait(
      pendingFriendsIds
          .map((id) => ref.read(userServiceProvider).getAppUserById(id)),
    );
    return pendingFriends.toISet();
  }

  Future<ISet<AppUser>> getCurrentUserRequestedFriends() async {
    final requestedFriendsIds =
        await _friendshipRepository.getCurrentUserRequestedFriendsIds();
    final requestedFriends = await Future.wait(
      requestedFriendsIds
          .map((id) => ref.read(userServiceProvider).getAppUserById(id)),
    );
    return requestedFriends.toISet();
  }

  Future<FriendshipStatus> currentUserFriendshipStatusWith(
    String userId,
  ) async {
    return _friendshipRepository.currentUserFriendshipStatusWith(userId);
  }

  Future<void> askFriendshipTo(String userId) async {
    return _friendshipRepository.askFriendshipTo(userId);
  }

  Future<void> acceptFriendshipWith(String userId) async {
    await _friendshipRepository.acceptFriendshipWith(userId);
  }

  Future<void> declineFriendshipWith(String userId) async {
    return _friendshipRepository.declineFriendshipWith(userId);
  }

  Future<void> cancelFriendshipRequest(String userId) async {
    return _friendshipRepository.cancelFriendshipRequest(userId);
  }

  Future<void> removeFriendshipWith(String userId) async {
    return _friendshipRepository.removeFriendshipWith(userId);
  }

  Future<ISet<AppUser>> _getFriendsByFriendsIds(ISet<String> friendsIds) async {
    final friends = await Future.wait(
      friendsIds.map((id) => ref.read(userServiceProvider).getAppUserById(id)),
    );
    return friends.toISet();
  }

  Future<ISet<AppUser>> _getMutualFriends(String userId) async {
    final mutualFriendsIds =
        await _friendshipRepository.getMutualFriendsIds(userId);
    return _getFriendsByFriendsIds(mutualFriendsIds);
  }

  Future<FriendDetails> getFriendDetails(String userId) async {
    final appUser = await ref.read(userServiceProvider).getAppUserById(userId);
    final mutualFriends = await _getMutualFriends(userId);
    final publicWishlists = await ref
        .read(wishlistServiceProvider)
        .getPublicWishlistsByUser(userId);
    final nbWishlists =
        await ref.read(wishlistServiceProvider).getNbWishlistsByUser(userId);
    final nbWishs =
        await ref.read(wishServiceProvider).getNbWishsByUser(userId);

    return FriendDetails(
      appUser: appUser,
      mutualFriends: mutualFriends,
      publicWishlists: publicWishlists,
      nbWishlists: nbWishlists,
      nbWishs: nbWishs,
    );
  }
}

final friendshipServiceProvider = Provider(
  (ref) => FriendshipService(ref.watch(friendshipRepositoryProvider), ref),
);
