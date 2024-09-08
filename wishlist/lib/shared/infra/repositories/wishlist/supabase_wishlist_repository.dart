import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/app_exception.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_repository.dart';
import 'package:wishlist/shared/models/wishlist/create_request/wishlist_create_request.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

class SupabaseWishlistRepository implements WishlistRepository {
  SupabaseWishlistRepository(this._client);
  final SupabaseClient _client;
  static const _wishlistsTableName = 'wishlists';

  @override
  Future<void> createWishlist(WishlistCreateRequest wishlist) async {
    try {
      await _client.from(_wishlistsTableName).insert(wishlist.toJson());
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
      final response = await _client
          .from(_wishlistsTableName)
          .select()
          .eq('id_owner', userId)
          .order('order', ascending: true);

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

  @override
  Future<void> updateWishlistsOrder(List<Wishlist> wishlists) async {
    try {
      for (final wishlist in wishlists) {
        final update = {
          'order': wishlists.indexOf(wishlist),
        };
        await _client
            .from(_wishlistsTableName)
            .update(update)
            .eq('id', wishlist.id);
      }
    } on PostgrestException catch (e) {
      final statusCode = e.code != null ? int.tryParse(e.code.toString()) : 500;
      throw AppException(
        statusCode: statusCode ?? 500,
        message: e.message,
      );
    } catch (e) {
      throw AppException(
        statusCode: 500,
        message: 'Failed to update wishlists',
      );
    }
  }
}
