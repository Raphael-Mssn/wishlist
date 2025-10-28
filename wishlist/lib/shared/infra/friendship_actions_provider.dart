import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/friendship_service.dart';

/// Provider pour les actions sur les friendships
///
/// Sépare les mutations (écriture) de la lecture (Realtime)
/// Les mutations passent par ce provider, qui appelle le service
/// Le StreamProvider Realtime détecte automatiquement les changements
final friendshipActionsProvider = Provider<FriendshipActions>((ref) {
  final service = ref.watch(friendshipServiceProvider);
  return FriendshipActions(service);
});

/// Classe qui expose toutes les actions possibles sur les friendships
///
/// Avantages :
/// - Séparation claire entre lecture (StreamProvider) et écriture (Actions)
/// - Facilite les tests (on peut mocker FriendshipActions)
/// - Plus explicite que d'appeler directement le service
class FriendshipActions {
  FriendshipActions(this._service);

  final FriendshipService _service;

  /// Envoyer une demande d'amitié
  Future<void> askFriendship(String userId) async {
    await _service.askFriendshipTo(userId);
  }

  /// Annuler une demande d'amitié envoyée
  Future<void> cancelFriendshipRequest(String userId) async {
    await _service.cancelFriendshipRequest(userId);
  }

  /// Accepter une demande d'amitié reçue
  Future<void> acceptFriendship(String userId) async {
    await _service.acceptFriendshipWith(userId);
  }

  /// Refuser une demande d'amitié reçue
  Future<void> declineFriendship(String userId) async {
    await _service.declineFriendshipWith(userId);
  }

  /// Supprimer une amitié existante
  Future<void> removeFriendship(String userId) async {
    await _service.removeFriendshipWith(userId);
  }
}
