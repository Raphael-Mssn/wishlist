import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/wish/supabase_wish_stream_repository.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_repository_provider.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_stream_repository.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';

/// Provider pour le repository de streaming des wishs
final wishStreamRepositoryProvider = Provider<WishStreamRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final wishRepository = ref.watch(wishRepositoryProvider);

  final repository = SupabaseWishStreamRepository(
    client,
    wishRepository,
  );

  // Cleanup automatique quand le provider est disposed
  ref.onDispose(repository.dispose);

  return repository;
});
