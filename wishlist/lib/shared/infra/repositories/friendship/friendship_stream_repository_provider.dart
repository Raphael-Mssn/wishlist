import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/friendship/friendship_repository_provider.dart';
import 'package:wishlist/shared/infra/repositories/friendship/friendship_stream_repository.dart';
import 'package:wishlist/shared/infra/repositories/friendship/supabase_friendship_stream_repository.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';

/// Provider pour le repository de streaming des friendships
final friendshipStreamRepositoryProvider =
    Provider<FriendshipStreamRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final friendshipRepository = ref.watch(friendshipRepositoryProvider);

  final repository = SupabaseFriendshipStreamRepository(
    client,
    friendshipRepository,
  );

  // Cleanup automatique quand le provider est disposed
  ref.onDispose(repository.dispose);

  return repository;
});
