import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/user/supabase_user_stream_repository.dart';
import 'package:wishlist/shared/infra/repositories/user/user_stream_repository.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';

/// Provider pour le repository de streaming des profiles
final userStreamRepositoryProvider = Provider<UserStreamRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);

  final repository = SupabaseUserStreamRepository(client);

  // Cleanup automatique quand le provider est disposed
  ref.onDispose(repository.dispose);

  return repository;
});
