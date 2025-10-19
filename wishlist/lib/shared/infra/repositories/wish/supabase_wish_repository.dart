import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_repository.dart';
import 'package:wishlist/shared/infra/utils/execute_safely.dart';
import 'package:wishlist/shared/models/booked_wish_with_details/booked_wish_with_details.dart';
import 'package:wishlist/shared/models/wish/create_request/wish_create_request.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

class SupabaseWishRepository implements WishRepository {
  SupabaseWishRepository(this._client);
  final SupabaseClient _client;
  static const _wishsTableName = 'wishs';
  static const _wishTakenByUserTableName = 'wish_taken_by_user';

  @override
  Future<IList<Wish>> getWishsFromWishlist(int wishlistId) async {
    return executeSafely(
      () async {
        final wishsJson = await _client
            .from(_wishsTableName)
            .select(
              '*, taken_by_user:$_wishTakenByUserTableName(*)',
            )
            .eq('wishlist_id', wishlistId)
            .order('is_favourite', ascending: false)
            .order('created_at');

        return wishsJson.map(Wish.fromJson).toIList();
      },
      errorMessage: 'Failed to get wishs from wishlist',
    );
  }

  @override
  Future<int> getNbWishsByUser(String userId) async {
    return executeSafely(
      () async {
        return await _client.rpc(
          'nb_wishs_by_user',
          params: {
            'user_id': userId,
          },
        );
      },
      errorMessage: 'Failed to get number of wishs by user',
    );
  }

  @override
  Future<IList<BookedWishWithDetails>> getBookedWishesByUser(
    String userId,
  ) async {
    return executeSafely(
      () async {
        final response =
            await _client.from(_wishTakenByUserTableName).select('''
              quantity,
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

          return BookedWishWithDetails(
            wish: Wish.fromJson(wishData),
            bookedQuantity: item['quantity'] as int,
            wishlistName: wishlistData['name'] as String,
            ownerId: wishlistData['id_owner'] as String,
            ownerPseudo: profileData['pseudo'] as String,
            ownerAvatarUrl: profileData['avatar_url'] as String?,
          );
        }).toIList();
      },
      errorMessage: 'Failed to get booked wishes by user',
    );
  }

  @override
  Future<Wish> createWish(WishCreateRequest wishCreateRequest) async {
    return executeSafely(
      () async {
        final wishJson = await _client
            .from(_wishsTableName)
            .insert(wishCreateRequest.toJson())
            .select()
            .single();

        final wish = Wish.fromJson(wishJson);

        return wish;
      },
      errorMessage: 'Failed to create wish',
    );
  }

  @override
  Future<Wish> updateWish(Wish wishToUpdate) async {
    return executeSafely(
      () async {
        final wishJson = await _client
            .from(_wishsTableName)
            .update(wishToUpdate.toJson())
            .eq('id', wishToUpdate.id)
            .select(
              '*, taken_by_user:$_wishTakenByUserTableName(*)',
            )
            .single();

        final wish = Wish.fromJson(wishJson);

        return wish;
      },
      errorMessage: 'Failed to update wish',
    );
  }

  @override
  Future<void> deleteWish(int wishId) async {
    return executeSafely(
      () async {
        await _client.from(_wishsTableName).delete().eq('id', wishId);
      },
      errorMessage: 'Failed to delete wish',
    );
  }
}
