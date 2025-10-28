import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/modules/friends/view/infra/search_notifier.dart';
import 'package:wishlist/shared/infra/auth_service.dart';
import 'package:wishlist/shared/infra/current_user_avatar_provider.dart';
import 'package:wishlist/shared/infra/repositories/friendship/friendship_repository_provider.dart';
import 'package:wishlist/shared/infra/repositories/user/user_repository_provider.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';

/// ♻️ Invalide tous les providers lors de la déconnexion
///
/// Cette fonction est appelée uniquement lors du `signOut()` pour :
/// - Réinitialiser l'état de l'application
/// - Nettoyer les données de l'utilisateur précédent
/// - Fermer les connexions Realtime (via supabaseClientProvider)
///
/// ⚠️ Important :
/// - Ne PAS invalider les StreamProviders Realtime manuellement (ils se nettoient automatiquement)
/// - Ne PAS appeler cette fonction après des mutations (Realtime gère les mises à jour)
/// - Cette fonction est UNIQUEMENT pour la déconnexion
void invalidateAllProviders(WidgetRef ref) {
  // Réinitialiser la recherche d'amis
  ref.invalidate(searchProvider);

  // Réinitialiser les services et le client Supabase (ferme les connexions Realtime)
  ref.invalidate(authServiceProvider);
  ref.invalidate(supabaseClientProvider);

  // Réinitialiser les repositories (write-only)
  ref.invalidate(friendshipRepositoryProvider);
  ref.invalidate(userRepositoryProvider);

  // Effacer l'avatar de l'utilisateur
  ref.invalidate(currentUserAvatarProvider);

  // ✅ Les StreamProviders Realtime (wishlists, friendships, etc.) se nettoient automatiquement
  //    quand supabaseClientProvider est invalidé
}
