import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/app_exception.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_repository.dart';
import 'package:wishlist/shared/models/wish/create_request/wish_create_request.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

class SupabaseWishRepository implements WishRepository {
  SupabaseWishRepository(this._client);
  final SupabaseClient _client;
  static const _wishsTableName = 'wishs';

  @override
  Future<IList<Wish>> getWishsFromWishlist(int wishlistId) async {
    try {
      final wishsJson = await _client
          .from(_wishsTableName)
          .select()
          .eq('wishlist_id', wishlistId);

      return wishsJson.map(Wish.fromJson).toIList();
    } on PostgrestException catch (e) {
      final statusCode = e.code != null ? int.tryParse(e.code.toString()) : 500;
      throw AppException(
        statusCode: statusCode ?? 500,
        message: e.message,
      );
    } catch (e) {
      throw AppException(
        statusCode: 500,
        message: 'Failed to get wishs from wishlist',
      );
    }
  }

  @override
  Future<int> getNbWishsByUser(String userId) async {
    try {
      final response = await _client
          .from('wishlists')
          .select('wishs(id)')
          .eq('id_owner', userId)
          .not('wishs', 'is', null)
          .count();

      return response.count;
    } on PostgrestException catch (e) {
      final statusCode = e.code != null ? int.tryParse(e.code.toString()) : 500;
      throw AppException(
        statusCode: statusCode ?? 500,
        message: e.message,
      );
    } catch (e) {
      throw AppException(
        statusCode: 500,
        message: 'Failed to get number of wishs by user',
      );
    }
  }

  @override
  Future<Wish> createWish(
    WishCreateRequest wishCreateRequest,
  ) async {
    try {
      final wishJson = await _client
          .from(_wishsTableName)
          .insert(wishCreateRequest.toJson())
          .select()
          .single();

      final wish = Wish.fromJson(wishJson);

      return wish;
    } on PostgrestException catch (e) {
      final statusCode = e.code != null ? int.tryParse(e.code.toString()) : 500;
      throw AppException(
        statusCode: statusCode ?? 500,
        message: e.message,
      );
    } catch (e) {
      throw AppException(
        statusCode: 500,
        message: 'Failed to create wish',
      );
    }
  }

  @override
  Future<Wish> updateWish(
    Wish wishToUpdate,
  ) async {
    try {
      final wishJson = await _client
          .from(_wishsTableName)
          .update(wishToUpdate.toJson())
          .eq('id', wishToUpdate.id)
          .select()
          .single();

      final wish = Wish.fromJson(wishJson);

      return wish;
    } on PostgrestException catch (e) {
      final statusCode = e.code != null ? int.tryParse(e.code.toString()) : 500;
      throw AppException(
        statusCode: statusCode ?? 500,
        message: e.message,
      );
    } catch (e) {
      throw AppException(
        statusCode: 500,
        message: 'Failed to update wish',
      );
    }
  }

  @override
  Future<void> deleteWish(int wishId) async {
    try {
      await _client.from(_wishsTableName).delete().eq('id', wishId);
    } on PostgrestException catch (e) {
      final statusCode = e.code != null ? int.tryParse(e.code.toString()) : 500;
      throw AppException(
        statusCode: statusCode ?? 500,
        message: e.message,
      );
    } catch (e) {
      throw AppException(
        statusCode: 500,
        message: 'Failed to delete wish',
      );
    }
  }
}
