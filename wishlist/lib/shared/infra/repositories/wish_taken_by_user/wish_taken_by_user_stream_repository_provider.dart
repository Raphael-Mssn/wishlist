import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/wish_taken_by_user/supabase_wish_taken_by_user_stream_repository.dart';
import 'package:wishlist/shared/infra/repositories/wish_taken_by_user/wish_taken_by_user_stream_repository.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';

final wishTakenByUserStreamRepositoryProvider =
    Provider.autoDispose<WishTakenByUserStreamRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final repository = SupabaseWishTakenByUserStreamRepository(client);

  ref.onDispose(repository.dispose);

  return repository;
});
