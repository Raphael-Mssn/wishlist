import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:wishlist/shared/models/friendship/friendship.dart';

abstract class FriendshipRepository {
  Future<ISet<String>> getFriendsIds(String userId);

  Future<ISet<String>> getCurrentUserFriendsIds();

  Future<ISet<String>> getCurrentUserPendingFriendsIds();

  Future<ISet<String>> getCurrentUserRequestedFriendsIds();

  Future<ISet<String>> getMutualFriendsIds(String userId);

  Future<FriendshipStatus> currentUserFriendshipStatusWith(String userId);

  Future<void> askFriendshipTo(String userId);

  Future<void> cancelFriendshipRequest(String userId);

  Future<void> acceptFriendshipWith(String userId);

  Future<void> declineFriendshipWith(String userId);

  Future<void> removeFriendshipWith(String userId);
}
