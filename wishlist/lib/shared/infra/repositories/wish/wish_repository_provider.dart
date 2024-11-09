import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/wish/supabase_wish_repository.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_repository.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';

final wishRepositoryProvider = Provider<WishRepository>((ref) {
  return SupabaseWishRepository(ref.watch(supabaseClientProvider));
});
