import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/supabase_wishlist_stream_repository.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_repository_provider.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_stream_repository.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';

final wishlistStreamRepositoryProvider =
    Provider<WishlistStreamRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final wishlistRepository = ref.watch(wishlistRepositoryProvider);

  final repository = SupabaseWishlistStreamRepository(
    client,
    wishlistRepository,
  );

  ref.onDispose(repository.dispose);

  return repository;
});
