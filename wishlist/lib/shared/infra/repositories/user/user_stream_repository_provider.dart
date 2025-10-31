import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/user/supabase_user_stream_repository.dart';
import 'package:wishlist/shared/infra/repositories/user/user_stream_repository.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';

final userStreamRepositoryProvider = Provider<UserStreamRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);

  final repository = SupabaseUserStreamRepository(client);

  ref.onDispose(repository.dispose);

  return repository;
});
