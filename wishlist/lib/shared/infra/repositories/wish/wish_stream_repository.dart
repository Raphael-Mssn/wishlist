import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:wishlist/shared/models/booked_wish_with_details/booked_wish_with_details.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

/// Interface pour écouter les changements en temps réel sur les wishs
/// (souhaits)
abstract class WishStreamRepository {
  /// Écoute tous les changements sur les wishs d'une wishlist
  ///
  /// Émet une nouvelle liste à chaque changement (INSERT, UPDATE, DELETE)
  Stream<IList<Wish>> watchWishsFromWishlist(int wishlistId);

  /// Écoute tous les wishs réservés par un utilisateur
  ///
  /// Émet une nouvelle liste à chaque changement dans wish_taken_by_user,
  /// wishs, wishlists ou profiles
  Stream<IList<BookedWishWithDetails>> watchBookedWishesByUser(String userId);

  /// Écoute les changements sur un wish spécifique
  ///
  /// Émet le wish mis à jour à chaque changement
  Stream<Wish> watchWishById(int wishId);

  /// Ferme tous les streams et libère les ressources
  Future<void> dispose();
}
