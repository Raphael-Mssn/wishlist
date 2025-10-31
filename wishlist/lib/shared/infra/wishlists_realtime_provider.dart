import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/non_null_extensions/go_true_client_non_null_getter_user_extension.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_stream_repository_provider.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

final wishlistsRealtimeProvider = StreamProvider<List<Wishlist>>((ref) {
  final userId = ref.watch(supabaseClientProvider).auth.currentUserNonNull.id;
  final repository = ref.watch(wishlistStreamRepositoryProvider);

  return repository
      .watchWishlistsByUser(userId)
      .map((wishlists) => wishlists.toList());
});
