import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

/// Interface pour écouter les changements en temps réel sur les wishs (souhaits)
abstract class WishStreamRepository {
  /// Écoute tous les changements sur les wishs d'une wishlist
  ///
  /// Émet une nouvelle liste à chaque changement (INSERT, UPDATE, DELETE)
  Stream<IList<Wish>> watchWishsFromWishlist(int wishlistId);

  /// Ferme tous les streams et libère les ressources
  Future<void> dispose();
}
