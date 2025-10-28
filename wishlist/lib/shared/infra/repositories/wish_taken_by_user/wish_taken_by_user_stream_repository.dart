import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:wishlist/shared/models/wish_taken_by_user/wish_taken_by_user.dart';

/// Repository abstrait pour les opérations Realtime sur les wish_taken_by_user
///
/// Cette table gère les réservations de souhaits par les utilisateurs
/// (qui a pris/réservé quel souhait et en quelle quantité)
abstract class WishTakenByUserStreamRepository {
  /// Écoute tous les changements sur les réservations d'un wish spécifique
  ///
  /// Émet une nouvelle liste à chaque INSERT/UPDATE/DELETE sur wish_taken_by_user
  /// pour le wishId donné
  Stream<IList<WishTakenByUser>> watchTakenByUsersForWish(int wishId);

  /// Écoute tous les changements sur les réservations faites par un utilisateur
  ///
  /// Utile pour afficher "mes réservations"
  Stream<IList<WishTakenByUser>> watchTakenByUser(String userId);

  /// Nettoie les ressources (channels Realtime)
  void dispose();
}
