import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/friendship/friendship_repository.dart';
import 'package:wishlist/shared/infra/repositories/friendship/supabase_friendship_repository.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';

final friendshipRepositoryProvider = Provider<FriendshipRepository>((ref) {
  return SupabaseFriendshipRepository(ref.watch(supabaseClientProvider));
});
