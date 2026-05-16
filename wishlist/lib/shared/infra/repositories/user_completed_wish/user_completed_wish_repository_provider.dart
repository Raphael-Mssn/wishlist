import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/user_completed_wish/supabase_user_completed_wish_repository.dart';
import 'package:wishlist/shared/infra/repositories/user_completed_wish/user_completed_wish_repository.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';

final userCompletedWishRepositoryProvider =
    Provider<UserCompletedWishRepository>((ref) {
  return SupabaseUserCompletedWishRepository(
    ref.watch(supabaseClientProvider),
  );
});
