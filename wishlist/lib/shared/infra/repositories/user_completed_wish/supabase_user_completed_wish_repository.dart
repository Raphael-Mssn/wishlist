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
    required int quantity,
  }) async {
    return executeSafely(
      () async {
        final existing = await _client
            .from(_tableName)
            .select('quantity')
            .eq('user_id', userId)
            .eq('wish_id', wishId)
            .maybeSingle();

        if (existing != null) {
          final newQuantity = (existing['quantity'] as num).toInt() + quantity;
          await _client
              .from(_tableName)
              .update({'quantity': newQuantity})
              .eq('user_id', userId)
              .eq('wish_id', wishId);
        } else {
          await _client.from(_tableName).insert({
            'user_id': userId,
            'wish_id': wishId,
            'from_wishlist_id': fromWishlistId,
            'quantity': quantity,
          });
        }
      },
      errorMessage: 'Failed to mark wish as completed',
    );
  }

  @override
  Future<void> updateCompletedWishQuantity({
    required String userId,
    required int wishId,
    required int newQuantity,
  }) async {
    return executeSafely(
      () async {
        await _client
            .from(_tableName)
            .update({'quantity': newQuantity})
            .eq('user_id', userId)
            .eq('wish_id', wishId);
      },
      errorMessage: 'Failed to update completed wish quantity',
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
  Future<void> restoreCompletedWish({
    required int wishId,
    required int targetWishlistId,
  }) async {
    return executeSafely(
      () async {
        await _client.rpc(
          'restore_completed_wish',
          params: {
            'p_wish_id': wishId,
            'p_target_wishlist_id': targetWishlistId,
          },
        );
      },
      errorMessage: 'Failed to restore completed wish',
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
               created_at,
               quantity,
               from_wishlist:wishlists!inner(
                 name,
                 deleted_at,
                 id_owner,
                 profiles!inner(
                   pseudo,
                   avatar_url
                 )
               ),
               wishs!inner(
                 *,
                 taken_by_user:$_wishTakenByUserTableName(*)
               )
            ''').eq('user_id', userId).order('created_at', ascending: false);

        return response.map((item) {
          final wishData = item['wishs'] as Map<String, dynamic>;
          final wishlistData = item['from_wishlist'] as Map<String, dynamic>;
          final profileData = wishlistData['profiles'] as Map<String, dynamic>;

          return CompletedWishWithDetails(
            wish: Wish.fromJson(wishData),
            fromWishlistId: item['from_wishlist_id'] as int,
            fromWishlistName: wishlistData['deleted_at'] == null
                ? wishlistData['name'] as String
                : CompletedWishWithDetails.deletedWishlistName,
            ownerId: wishlistData['id_owner'] as String,
            ownerPseudo: profileData['pseudo'] as String,
            ownerAvatarUrl: profileData['avatar_url'] as String?,
            completedAt: DateTime.parse(item['created_at'] as String),
            quantity: (item['quantity'] as num).toInt(),
          );
        }).toIList();
      },
      errorMessage: 'Failed to get completed wishes by user',
    );
  }
}
