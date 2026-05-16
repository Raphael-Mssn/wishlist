import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/user_completed_wish/supabase_user_completed_wish_stream_repository.dart';
import 'package:wishlist/shared/infra/repositories/user_completed_wish/user_completed_wish_repository_provider.dart';
import 'package:wishlist/shared/infra/repositories/user_completed_wish/user_completed_wish_stream_repository.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';

final userCompletedWishStreamRepositoryProvider =
    Provider.autoDispose<UserCompletedWishStreamRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final repository = ref.watch(userCompletedWishRepositoryProvider);

  final streamRepository = SupabaseUserCompletedWishStreamRepository(
    client,
    repository,
  );

  ref.onDispose(streamRepository.dispose);

  return streamRepository;
});
