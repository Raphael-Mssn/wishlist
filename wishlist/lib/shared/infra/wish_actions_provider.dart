import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/wish_service.dart';
import 'package:wishlist/shared/models/wish/create_request/wish_create_request.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

/// Provider pour les actions sur les wishs
///
/// Sépare les mutations (écriture) de la lecture (Realtime)
final wishActionsProvider = Provider<WishActions>((ref) {
  final service = ref.watch(wishServiceProvider);
  return WishActions(service);
});

/// Classe qui expose toutes les actions possibles sur les wishs
class WishActions {
  WishActions(this._service);

  final WishService _service;

  /// Créer un nouveau wish
  Future<Wish> createWish(WishCreateRequest request) async {
    return _service.createWish(request);
  }

  /// Mettre à jour un wish
  Future<Wish> updateWish(Wish wish) async {
    return _service.updateWish(wish);
  }

  /// Supprimer un wish
  Future<void> deleteWish(int wishId) async {
    await _service.deleteWish(wishId);
  }
}
