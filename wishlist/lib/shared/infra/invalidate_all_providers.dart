import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/modules/friends/view/infra/search_notifier.dart';
import 'package:wishlist/shared/infra/auth_service.dart';
import 'package:wishlist/shared/infra/current_user_avatar_provider.dart';
import 'package:wishlist/shared/infra/repositories/friendship/friendship_repository_provider.dart';
import 'package:wishlist/shared/infra/repositories/friendship/friendship_stream_repository_provider.dart';
import 'package:wishlist/shared/infra/repositories/user/user_repository_provider.dart';
import 'package:wishlist/shared/infra/repositories/user/user_stream_repository_provider.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_stream_repository_provider.dart';
import 'package:wishlist/shared/infra/repositories/wish_taken_by_user/wish_taken_by_user_stream_repository_provider.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_stream_repository_provider.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';

/// ♻️ Invalide tous les providers lors de la déconnexion
///
/// Cette fonction est appelée uniquement lors du `signOut()` pour :
/// - Réinitialiser l'état de l'application
/// - Nettoyer les données de l'utilisateur précédent
/// - Fermer les connexions Realtime
///
/// ⚠️ Important :
/// - Ne PAS appeler cette fonction après des mutations (Realtime gère les mises à jour)
/// - Cette fonction est UNIQUEMENT pour la déconnexion
void invalidateAllProviders(WidgetRef ref) {
  // Réinitialiser la recherche d'amis
  ref.invalidate(searchProvider);

  // Réinitialiser les services
  ref.invalidate(authServiceProvider);

  // Effacer l'avatar de l'utilisateur
  ref.invalidate(currentUserAvatarProvider);

  // Réinitialiser les repositories (write-only)
  ref.invalidate(friendshipRepositoryProvider);
  ref.invalidate(userRepositoryProvider);

  // Réinitialiser les stream repositories (ferme les connexions Realtime et vide les caches)
  ref.invalidate(wishlistStreamRepositoryProvider);
  ref.invalidate(wishStreamRepositoryProvider);
  ref.invalidate(wishTakenByUserStreamRepositoryProvider);
  ref.invalidate(friendshipStreamRepositoryProvider);
  ref.invalidate(userStreamRepositoryProvider);

  // Réinitialiser le client Supabase (doit être invalidé en dernier)
  ref.invalidate(supabaseClientProvider);
}
