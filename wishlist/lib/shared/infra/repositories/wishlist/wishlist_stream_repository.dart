import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

/// Interface pour écouter les changements en temps réel sur les wishlists
abstract class WishlistStreamRepository {
  /// Écoute tous les changements sur les wishlists d'un utilisateur
  ///
  /// Émet une nouvelle liste à chaque changement (INSERT, UPDATE, DELETE)
  Stream<IList<Wishlist>> watchWishlistsByUser(String userId);

  /// Écoute les changements sur une wishlist spécifique
  ///
  /// Émet la wishlist mise à jour à chaque changement
  Stream<Wishlist?> watchWishlistById(int wishlistId);

  /// Écoute uniquement les wishlists publiques d'un utilisateur
  Stream<IList<Wishlist>> watchPublicWishlistsByUser(String userId);

  /// Ferme tous les streams et libère les ressources
  Future<void> dispose();
}
