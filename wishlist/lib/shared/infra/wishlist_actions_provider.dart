import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/wishlist_service.dart';
import 'package:wishlist/shared/models/wishlist/create_request/wishlist_create_request.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

/// Provider pour les actions sur les wishlists
///
/// Sépare les mutations (écriture) de la lecture (Realtime)
final wishlistActionsProvider = Provider<WishlistActions>((ref) {
  final service = ref.watch(wishlistServiceProvider);
  return WishlistActions(service);
});

/// Classe qui expose toutes les actions possibles sur les wishlists
class WishlistActions {
  WishlistActions(this._service);

  final WishlistService _service;

  /// Créer une nouvelle wishlist
  Future<Wishlist> createWishlist(WishlistCreateRequest request) async {
    return _service.createWishlist(request);
  }

  /// Mettre à jour une wishlist
  Future<Wishlist> updateWishlist(Wishlist wishlist) async {
    return _service.updateWishlist(wishlist);
  }

  /// Supprimer une wishlist
  Future<void> deleteWishlist(int wishlistId) async {
    await _service.deleteWishlist(wishlistId);
  }
}
