import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/non_null_extensions/go_true_client_non_null_getter_user_extension.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_stream_repository_provider.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

/// 🔄 Version Realtime du wishlistsProvider
///
/// Cette version utilise Supabase Realtime pour mettre à jour
/// automatiquement la liste des wishlists sans avoir à appeler
/// manuellement loadWishlists().
///
/// Migration depuis l'ancienne version :
///
/// AVANT (wishlists_provider.dart) :
/// ```dart
/// final wishlists = ref.watch(wishlistsProvider);
///
/// // Pour rafraîchir, il fallait faire :
/// await ref.read(wishlistsProvider.notifier).loadWishlists(userId);
/// ```
///
/// APRÈS (avec ce provider) :
/// ```dart
/// final wishlists = ref.watch(wishlistsRealtimeProvider);
///
/// // Plus besoin de rafraîchir manuellement !
/// // Les données se mettent à jour automatiquement en temps réel
/// ```
///
/// Les avantages :
/// - ✅ Mise à jour automatique en temps réel
/// - ✅ Synchronisation entre plusieurs appareils/sessions
/// - ✅ Moins de code à maintenir (pas besoin de loadWishlists partout)
/// - ✅ Meilleure UX (pas de latence entre une action et la mise à jour)
final wishlistsRealtimeProvider = StreamProvider<List<Wishlist>>((ref) {
  final userId = ref.watch(supabaseClientProvider).auth.currentUserNonNull.id;
  final repository = ref.watch(wishlistStreamRepositoryProvider);

  // Écouter les changements en temps réel et convertir IList en List
  return repository
      .watchWishlistsByUser(userId)
      .map((wishlists) => wishlists.toList());
});

/// 📝 Note pour la migration :
///
/// Le StreamProvider retourne un AsyncValue que vous utilisez avec .when() :
/// ```dart
/// final wishlists = ref.watch(wishlistsRealtimeProvider);
///
/// return wishlists.when(
///   data: (data) => WishlistsGrid(wishlists: data),
///   loading: () => CircularProgressIndicator(),
///   error: (error, _) => Text('Erreur: $error'),
/// );
/// ```
///
/// C'est la même API que l'ancien StateNotifierProvider !
/// Pas besoin de modifier votre code UI.
