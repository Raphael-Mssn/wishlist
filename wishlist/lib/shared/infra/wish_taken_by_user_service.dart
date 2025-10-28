import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/infra/wish_taken_by_user_actions_provider.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/models/wish_taken_by_user/create_request/wish_taken_by_user_create_request.dart';

class WishTakenByUserService {
  WishTakenByUserService(this._actions, this.ref);
  final WishTakenByUserActions _actions;
  final Ref ref;

  Future<void> wishTakenByUser(
    Wish wish, {
    int? quantity,
  }) async {
    final currentUserId = ref.read(userServiceProvider).getCurrentUserId();
    final quantityToReserve = quantity ?? 1;

    // Vérifier si l'utilisateur a déjà une réservation pour ce wish
    final existingReservation = wish.takenByUser
        .where(
          (reservation) => reservation.userId == currentUserId,
        )
        .firstOrNull;

    if (existingReservation != null) {
      // Mettre à jour la réservation existante en additionnant les quantités
      final newQuantity = existingReservation.quantity + quantityToReserve;
      await _actions.updateWishTakenByUser(
        wishId: wish.id,
        userId: currentUserId,
        newQuantity: newQuantity,
      );
    } else {
      // Créer une nouvelle réservation
      final wishTakenByUserCreateRequest = WishTakenByUserCreateRequest(
        wishId: wish.id,
        userId: currentUserId,
        quantity: quantityToReserve,
      );

      await _actions.createWishTakenByUser(
        wishTakenByUserCreateRequest,
      );
    }
  }

  Future<void> cancelWishTaken(Wish wish) async {
    await _actions.cancelWishTaken(wish.id);
  }
}

final wishTakenByUserServiceProvider = Provider(
  (ref) => WishTakenByUserService(
    ref.watch(wishTakenByUserActionsProvider),
    ref,
  ),
);
