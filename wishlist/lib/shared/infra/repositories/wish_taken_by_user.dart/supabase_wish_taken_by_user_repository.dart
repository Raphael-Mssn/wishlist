import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/repositories/wish_taken_by_user.dart/wish_taken_by_user_repository.dart';
import 'package:wishlist/shared/infra/utils/execute_safely.dart';
import 'package:wishlist/shared/models/wish_taken_by_user/create_request/wish_taken_by_user_create_request.dart';

class SupabaseWishTakenByUserRepository implements WishTakenByUserRepository {
  SupabaseWishTakenByUserRepository(this._client);
  final SupabaseClient _client;
  static const _wishTakenByUser = 'wish_taken_by_user';

  @override
  Future<void> createWishTakenByUser(
    WishTakenByUserCreateRequest wishTakenByUserCreateRequest,
  ) async {
    return executeSafely(
      () async {
        await _client
            .from(_wishTakenByUser)
            .insert(wishTakenByUserCreateRequest.toJson());
      },
      errorMessage: 'Failed to user want to give wish',
    );
  }

  @override
  Future<void> updateWishTakenByUser({
    required int wishId,
    required String userId,
    required int newQuantity,
  }) async {
    return executeSafely(
      () async {
        await _client
            .from(_wishTakenByUser)
            .update({
              'quantity': newQuantity,
              'updated_at': DateTime.now().toUtc().toIso8601String(),
            })
            .eq('wish_id', wishId)
            .eq('user_id', userId);
      },
      errorMessage: 'Failed to update wish taken by user',
    );
  }

  @override
  Future<void> cancelWishTaken(int wishId) async {
    return executeSafely(
      () async {
        await _client.from(_wishTakenByUser).delete().eq('wish_id', wishId);
      },
      errorMessage: 'Failed to cancel wish taken by user',
    );
  }
}
