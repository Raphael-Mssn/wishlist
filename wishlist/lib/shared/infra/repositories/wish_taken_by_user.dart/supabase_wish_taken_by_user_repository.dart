import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/app_exception.dart';
import 'package:wishlist/shared/infra/repositories/wish_taken_by_user.dart/wish_taken_by_user_repository.dart';
import 'package:wishlist/shared/models/wish_taken_by_user/create_request/wish_taken_by_user_create_request.dart';

class SupabaseWishTakenByUserRepository implements WishTakenByUserRepository {
  SupabaseWishTakenByUserRepository(this._client);
  final SupabaseClient _client;
  static const _wishTakenByUser = 'wish_taken_by_user';

  @override
  Future<void> createWishTakenByUser(
    WishTakenByUserCreateRequest wishTakenByUserCreateRequest,
  ) async {
    try {
      await _client.from(_wishTakenByUser).insert(wishTakenByUserCreateRequest);
    } on PostgrestException catch (e) {
      final statusCode = e.code != null ? int.tryParse(e.code.toString()) : 500;
      throw AppException(
        statusCode: statusCode ?? 500,
        message: e.message,
      );
    } catch (e) {
      throw AppException(
        statusCode: 500,
        message: 'Failed to user want to give wish',
      );
    }
  }

  @override
  Future<void> cancelWishTaken(int wishId) async {
    try {
      await _client.from(_wishTakenByUser).delete().eq('wish_id', wishId);
    } on PostgrestException catch (e) {
      final statusCode = e.code != null ? int.tryParse(e.code.toString()) : 500;
      throw AppException(
        statusCode: statusCode ?? 500,
        message: e.message,
      );
    } catch (e) {
      throw AppException(
        statusCode: 500,
        message: 'Failed to user want to give wish',
      );
    }
  }
}
