import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/user/supabase_user_repository.dart';
import 'package:wishlist/shared/infra/repositories/user/user_repository.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';

final userRepositoryProvider = Provider.autoDispose<UserRepository>((ref) {
  return SupabaseUserRepository(ref.watch(supabaseClientProvider));
});
