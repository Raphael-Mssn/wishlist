import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/wish_taken_by_user.dart/supabase_wish_taken_by_user_repository.dart';
import 'package:wishlist/shared/infra/repositories/wish_taken_by_user.dart/wish_taken_by_user_repository.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';

final wishTakenByUserRepositoryProvider =
    Provider<WishTakenByUserRepository>((ref) {
  return SupabaseWishTakenByUserRepository(ref.watch(supabaseClientProvider));
});
