import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/wish_taken_by_user.dart/wish_taken_by_user_repository.dart';
import 'package:wishlist/shared/infra/repositories/wish_taken_by_user.dart/wish_taken_by_user_repository_provider.dart';
import 'package:wishlist/shared/models/wish_taken_by_user/create_request/wish_taken_by_user_create_request.dart';

/// Provider pour les actions sur les wish_taken_by_user
///
/// Sépare les mutations (écriture) de la lecture (Realtime)
final wishTakenByUserActionsProvider = Provider<WishTakenByUserActions>((ref) {
  final repository = ref.watch(wishTakenByUserRepositoryProvider);
  return WishTakenByUserActions(repository);
});

/// Classe qui expose toutes les actions possibles sur les wish_taken_by_user
class WishTakenByUserActions {
  WishTakenByUserActions(this._repository);

  final WishTakenByUserRepository _repository;

  /// Créer une nouvelle réservation
  Future<void> createWishTakenByUser(
    WishTakenByUserCreateRequest request,
  ) async {
    await _repository.createWishTakenByUser(request);
  }

  /// Mettre à jour une réservation existante
  Future<void> updateWishTakenByUser({
    required int wishId,
    required String userId,
    required int newQuantity,
  }) async {
    await _repository.updateWishTakenByUser(
      wishId: wishId,
      userId: userId,
      newQuantity: newQuantity,
    );
  }

  /// Annuler/supprimer une réservation
  Future<void> cancelWishTaken(int wishId) async {
    await _repository.cancelWishTaken(wishId);
  }
}
