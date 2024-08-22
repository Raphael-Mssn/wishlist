import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/supabase_wishlist_repository.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_repository.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  return SupabaseWishlistRepository(ref.watch(supabaseClientProvider));
});
