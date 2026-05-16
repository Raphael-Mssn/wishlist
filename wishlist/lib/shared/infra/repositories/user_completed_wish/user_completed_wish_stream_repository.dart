import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:wishlist/shared/models/completed_wish_with_details/completed_wish_with_details.dart';

/// Repository abstrait pour les opérations Realtime sur user_completed_wishs.
abstract class UserCompletedWishStreamRepository {
  /// Écoute tous les wishs complétés d'un utilisateur avec leurs détails.
  ///
  /// Émet une nouvelle liste à chaque INSERT/DELETE sur user_completed_wishs,
  /// ou quand les données liées (wishs, wishlists, profiles) changent.
  Stream<IList<CompletedWishWithDetails>> watchCompletedWishesByUser(
    String userId,
  );

  /// Nettoie les ressources (channels Realtime).
  void dispose();
}
