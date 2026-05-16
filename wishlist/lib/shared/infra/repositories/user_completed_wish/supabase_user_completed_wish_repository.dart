import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/repositories/user_completed_wish/user_completed_wish_repository.dart';
import 'package:wishlist/shared/infra/utils/execute_safely.dart';
import 'package:wishlist/shared/models/completed_wish_with_details/completed_wish_with_details.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

class SupabaseUserCompletedWishRepository
    implements UserCompletedWishRepository {
  SupabaseUserCompletedWishRepository(this._client);

  final SupabaseClient _client;
  static const _tableName = 'user_completed_wishs';
  static const _wishTakenByUserTableName = 'wish_taken_by_user';

  @override
  Future<void> markAsCompleted({
    required String userId,
    required int wishId,
    required int fromWishlistId,
  }) async {
    return executeSafely(
      () async {
        await _client.from(_tableName).insert({
          'user_id': userId,
          'wish_id': wishId,
          'from_wishlist_id': fromWishlistId,
        });
      },
      errorMessage: 'Failed to mark wish as completed',
    );
  }

  @override
  Future<void> unmarkAsCompleted({
    required String userId,
    required int wishId,
  }) async {
    return executeSafely(
      () async {
        await _client
            .from(_tableName)
            .delete()
            .eq('user_id', userId)
            .eq('wish_id', wishId);
      },
      errorMessage: 'Failed to unmark wish as completed',
    );
  }

  @override
  Future<IList<CompletedWishWithDetails>> getCompletedWishesByUser(
    String userId,
  ) async {
    return executeSafely(
      () async {
        final response = await _client.from(_tableName).select('''
              from_wishlist_id,
              wishs!inner(
                *,
                taken_by_user:$_wishTakenByUserTableName(*),
                wishlists!inner(
                  name,
                  id_owner,
                  profiles!inner(
                    pseudo,
                    avatar_url
                  )
                )
              )
            ''').eq('user_id', userId).order('created_at', ascending: false);

        return response.map((item) {
          final wishData = item['wishs'] as Map<String, dynamic>;
          final wishlistData = wishData['wishlists'] as Map<String, dynamic>;
          final profileData = wishlistData['profiles'] as Map<String, dynamic>;

          return CompletedWishWithDetails(
            wish: Wish.fromJson(wishData),
            fromWishlistId: item['from_wishlist_id'] as int,
            fromWishlistName: wishlistData['name'] as String,
            ownerId: wishlistData['id_owner'] as String,
            ownerPseudo: profileData['pseudo'] as String,
            ownerAvatarUrl: profileData['avatar_url'] as String?,
          );
        }).toIList();
      },
      errorMessage: 'Failed to get completed wishes by user',
    );
  }
}
