import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/app_exception.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_repository.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

class SupabaseWishlistRepository implements WishlistRepository {
  SupabaseWishlistRepository(this._client);
  final SupabaseClient _client;

  @override
  Future<void> createWishlist(Wishlist wishlist) async {
    try {
      await _client.from('wishlists').insert(wishlist.toJson());
    } on PostgrestException catch (e) {
      final statusCode = e.code != null ? int.tryParse(e.code.toString()) : 500;
      throw AppException(
        statusCode: statusCode ?? 500,
        message: e.message,
      );
    } catch (e) {
      throw AppException(
        statusCode: 500,
        message: 'Failed to create wishlist',
      );
    }
  }

  @override
  Future<List<Wishlist>> getWishlistsByUser(String userId) async {
    try {
      final response =
          await _client.from('wishlists').select().eq('id_owner', userId);

      return response.map(Wishlist.fromJson).toList();
    } on PostgrestException catch (e) {
      final statusCode = e.code != null ? int.tryParse(e.code.toString()) : 500;
      throw AppException(
        statusCode: statusCode ?? 500,
        message: e.message,
      );
    } catch (e) {
      throw AppException(
        statusCode: 500,
        message: 'Failed to get wishlists',
      );
    }
  }
}
