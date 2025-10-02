import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/modules/friends/view/infra/search_notifier.dart';
import 'package:wishlist/shared/infra/auth_service.dart';
import 'package:wishlist/shared/infra/current_user_avatar_provider.dart';
import 'package:wishlist/shared/infra/friendship_status_provider.dart';
import 'package:wishlist/shared/infra/friendships_provider.dart';
import 'package:wishlist/shared/infra/repositories/friendship/friendship_repository_provider.dart';
import 'package:wishlist/shared/infra/repositories/user/user_repository_provider.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';
import 'package:wishlist/shared/infra/wishlists_provider.dart';

void invalidateAllProviders(WidgetRef ref) {
  ref.invalidate(searchProvider);
  ref.invalidate(authServiceProvider);
  ref.invalidate(supabaseClientProvider);
  ref.invalidate(friendshipsProvider);
  ref.invalidate(friendshipStatusProvider);
  ref.invalidate(friendshipRepositoryProvider);
  ref.invalidate(userRepositoryProvider);
  ref.invalidate(wishlistsProvider);
  ref.invalidate(currentUserAvatarProvider);
}
