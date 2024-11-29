import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/app_exception.dart';
import 'package:wishlist/shared/infra/non_null_extensions/go_true_client_non_null_getter_user_extension.dart';
import 'package:wishlist/shared/infra/repositories/friendship/friendship_repository.dart';
import 'package:wishlist/shared/infra/utils/execute_safely.dart';
import 'package:wishlist/shared/models/friendship/friendship.dart';

class SupabaseFriendshipRepository implements FriendshipRepository {
  SupabaseFriendshipRepository(this._client);
  final SupabaseClient _client;
  static const _friendshipsTableName = 'friendships';
  late String currentUserId = _client.auth.currentUserNonNull.id;

  @override
  Future<ISet<String>> getFriendsIds(String userId) async {
    return executeSafely(
      () async {
        final response = await _client
            .from(_friendshipsTableName)
            .select()
            .eq('status', FriendshipStatus.accepted.toString())
            .or('requester_id.eq.$userId,receiver_id.eq.$userId');

        final friendships = response.map(Friendship.fromJson).toIList();

        return friendships
            .where((friendship) => friendship.requesterId == userId)
            .map((friendship) => friendship.receiverId)
            .toISet()
            .addAll(
              friendships
                  .where((friendship) => friendship.receiverId == userId)
                  .map((friendship) => friendship.requesterId),
            );
      },
      errorMessage: 'Failed to get friendships',
    );
  }

  @override
  Future<ISet<String>> getCurrentUserFriendsIds() async {
    final currentUserId = _client.auth.currentUserNonNull.id;
    return getFriendsIds(currentUserId);
  }

  @override
  Future<ISet<String>> getCurrentUserPendingFriendsIds() async {
    return executeSafely(
      () async {
        final currentUserId = _client.auth.currentUserNonNull.id;
        final response = await _client
            .from(_friendshipsTableName)
            .select()
            .eq('status', FriendshipStatus.pending.toString())
            .eq('requester_id', currentUserId);

        final friendships = response.map(Friendship.fromJson).toIList();

        return friendships
            .where((friendship) => friendship.requesterId == currentUserId)
            .map((friendship) => friendship.receiverId)
            .toISet();
      },
      errorMessage: 'Failed to get pending friendships',
    );
  }

  @override
  Future<ISet<String>> getCurrentUserRequestedFriendsIds() async {
    return executeSafely(
      () async {
        final currentUserId = _client.auth.currentUserNonNull.id;
        final response = await _client
            .from(_friendshipsTableName)
            .select()
            .eq('status', FriendshipStatus.pending.toString())
            .eq('receiver_id', currentUserId);

        final friendships = response.map(Friendship.fromJson).toIList();

        return friendships
            .where((friendship) => friendship.receiverId == currentUserId)
            .map((friendship) => friendship.requesterId)
            .toISet();
      },
      errorMessage: 'Failed to get requested friendships',
    );
  }

  @override
  Future<ISet<String>> getMutualFriendsIds(String userId) async {
    final currentUserFriendsIds = await getCurrentUserFriendsIds();
    final userFriendsIds = await getFriendsIds(userId);

    return currentUserFriendsIds.intersection(userFriendsIds);
  }

  @override
  Future<FriendshipStatus> currentUserFriendshipStatusWith(
    String userId,
  ) async {
    return executeSafely(
      () async {
        final response = await _client
            .from(_friendshipsTableName)
            .select()
            .or('requester_id.eq.$currentUserId,receiver_id.eq.$currentUserId')
            .or('requester_id.eq.$userId,receiver_id.eq.$userId');

        if (response.isEmpty) {
          return FriendshipStatus.none;
        }

        final friendship = Friendship.fromJson(response.first);

        return friendship.status;
      },
      errorMessage: 'Failed to get friendship status',
    );
  }

  @override
  Future<void> askFriendshipTo(String userId) async {
    return executeSafely(
      () async {
        // Check if there is already a friendship request
        final isAlreadyFriendship = await _client
            .from(_friendshipsTableName)
            .select()
            .eq('requester_id', currentUserId)
            .eq('receiver_id', userId);

        if (isAlreadyFriendship.isNotEmpty) {
          throw AppException(
            statusCode: 400,
            message: 'Friendship request already exists',
          );
        }

        // If there is no friendship request, insert a new one
        await _client.from(_friendshipsTableName).insert(
              Friendship(
                status: FriendshipStatus.pending,
                requesterId: currentUserId,
                receiverId: userId,
              ),
            );
      },
      errorMessage: 'Failed to ask friendship',
    );
  }

  @override
  Future<void> cancelFriendshipRequest(String userId) async {
    return executeSafely(
      () async {
        await _client
            .from(_friendshipsTableName)
            .delete()
            .eq('requester_id', currentUserId)
            .eq('receiver_id', userId);
      },
      errorMessage: 'Failed to cancel friendship request',
    );
  }

  @override
  Future<void> acceptFriendshipWith(String userId) async {
    return executeSafely(
      () async {
        await _client
            .from(_friendshipsTableName)
            .update({'status': FriendshipStatus.accepted.toString()})
            .eq('requester_id', userId)
            .eq('receiver_id', currentUserId);
      },
      errorMessage: 'Failed to accept friendship',
    );
  }

  @override
  Future<void> declineFriendshipWith(String userId) async {
    return executeSafely(
      () async {
        await _client
            .from(_friendshipsTableName)
            .delete()
            .eq('requester_id', userId)
            .eq('receiver_id', currentUserId);
      },
      errorMessage: 'Failed to decline friendship',
    );
  }

  @override
  Future<void> removeFriendshipWith(String userId) async {
    return executeSafely(
      () async {
        await _client
            .from(_friendshipsTableName)
            .delete()
            .or('requester_id.eq.$currentUserId,receiver_id.eq.$currentUserId')
            .or('requester_id.eq.$userId,receiver_id.eq.$userId');
      },
      errorMessage: 'Failed to remove friendship',
    );
  }
}
