import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/avatar/avatar_repository.dart';
import 'package:wishlist/shared/infra/repositories/avatar/supabase_avatar_repository.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';

final avatarRepositoryProvider = Provider<AvatarRepository>((ref) {
  return SupabaseAvatarRepository(ref.watch(supabaseClientProvider));
});
