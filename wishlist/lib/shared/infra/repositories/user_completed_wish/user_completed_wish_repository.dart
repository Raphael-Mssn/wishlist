import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:wishlist/shared/models/completed_wish_with_details/completed_wish_with_details.dart';

abstract class UserCompletedWishRepository {
  /// Marque un wish comme complété pour l'utilisateur courant.
  Future<void> markAsCompleted({
    required String userId,
    required int wishId,
    required int fromWishlistId,
  });

  /// Retire un wish de l'état complété.
  Future<void> unmarkAsCompleted({
    required String userId,
    required int wishId,
  });

  /// Récupère tous les wishs complétés d'un utilisateur avec leurs détails.
  Future<IList<CompletedWishWithDetails>> getCompletedWishesByUser(
    String userId,
  );
}
