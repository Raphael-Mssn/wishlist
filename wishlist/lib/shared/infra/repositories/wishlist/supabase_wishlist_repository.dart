import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_repository.dart';
import 'package:wishlist/shared/infra/utils/execute_safely.dart';
import 'package:wishlist/shared/models/wishlist/create_request/wishlist_create_request.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

class SupabaseWishlistRepository implements WishlistRepository {
  SupabaseWishlistRepository(this._client);
  final SupabaseClient _client;
  static const _wishlistsTableName = 'wishlists';

  @override
  Future<Wishlist> createWishlist(
    WishlistCreateRequest wishlistCreateRequest,
  ) async {
    return executeSafely(
      () async {
        final wishlistJson = await _client
            .from(_wishlistsTableName)
            .insert(wishlistCreateRequest.toJson())
            .select()
            .single();

        return Wishlist.fromJson(wishlistJson);
      },
      errorMessage: 'Failed to create wishlist',
    );
  }

  @override
  Future<IList<Wishlist>> getWishlistsByUser(String userId) async {
    return executeSafely(
      () async {
        final response = await _client
            .from(_wishlistsTableName)
            .select()
            .eq('id_owner', userId)
            .order('order', ascending: true);

        return response.map(Wishlist.fromJson).toIList();
      },
      errorMessage: 'Failed to get wishlists',
    );
  }

  @override
  Future<IList<Wishlist>> getPublicWishlistsByUser(String userId) async {
    return executeSafely(
      () async {
        final response = await _client
            .from(_wishlistsTableName)
            .select()
            .eq('id_owner', userId)
            .eq('visibility', 'public')
            .order('order', ascending: true);

        return response.map(Wishlist.fromJson).toIList();
      },
      errorMessage: 'Failed to get public wishlists',
    );
  }

  @override
  Future<int> getNbWishlistsByUser(String userId) async {
    return executeSafely(
      () async {
        final response = await _client
            .from(_wishlistsTableName)
            .select('id')
            .eq('id_owner', userId)
            .count();

        return response.count;
      },
      errorMessage: 'Failed to get number of wishlists',
    );
  }

  @override
  Future<Wishlist> getWishlistById(int wishlistId) async {
    return executeSafely(
      () async {
        final response = await _client
            .from(_wishlistsTableName)
            .select()
            .eq('id', wishlistId)
            .single();

        return Wishlist.fromJson(response);
      },
      errorMessage: 'Failed to get wishlist',
    );
  }

  @override
  Future<Wishlist> updateWishlist(Wishlist wishlist) async {
    return executeSafely(
      () async {
        final wishlistJson = await _client
            .from(_wishlistsTableName)
            .update(wishlist.toJson())
            .eq('id', wishlist.id)
            .select()
            .single();

        return Wishlist.fromJson(wishlistJson);
      },
      errorMessage: 'Failed to update wishlist',
    );
  }

  @override
  Future<void> deleteWishlist(int wishlistId) async {
    return executeSafely(
      () async {
        await _client.from(_wishlistsTableName).delete().eq('id', wishlistId);
      },
      errorMessage: 'Failed to delete wishlist',
    );
  }
}
