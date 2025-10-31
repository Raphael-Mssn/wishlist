import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/non_null_extensions/go_true_client_non_null_getter_user_extension.dart';

/// Service pour gérer la présence en ligne des utilisateurs via Supabase Realtime
class PresenceService {
  PresenceService(this._client);

  final SupabaseClient _client;
  RealtimeChannel? _presenceChannel;
  final _onlineUsersController = StreamController<ISet<String>>.broadcast();
  ISet<String> _currentOnlineUsers = const ISetConst({});

  /// Stream des IDs des utilisateurs actuellement en ligne
  Stream<ISet<String>> get onlineUsersStream => _onlineUsersController.stream;

  /// IDs des utilisateurs actuellement en ligne
  ISet<String> get currentOnlineUsers => _currentOnlineUsers;

  /// Démarre le tracking de présence pour l'utilisateur actuel
  Future<void> startTracking() async {
    try {
      final currentUserId = _client.auth.currentUserNonNull.id;

      // Émettre une valeur initiale vide pour éviter le blocage en loading
      _onlineUsersController.add(_currentOnlineUsers);

      // Créer un channel unique pour la présence globale
      _presenceChannel = _client.channel('presence:global');

      // S'abonner aux changements de présence
      _presenceChannel!.onPresenceSync((_) {
        _updateOnlineUsersFromChannel();
      }).onPresenceJoin((_) {
        _updateOnlineUsersFromChannel();
      }).onPresenceLeave((_) {
        _updateOnlineUsersFromChannel();
      }).subscribe(
        (status, [error]) async {
          if (status == RealtimeSubscribeStatus.subscribed) {
            // Envoyer la présence de l'utilisateur actuel
            await _presenceChannel!.track({
              'user_id': currentUserId,
              'online_at': DateTime.now().toIso8601String(),
            });
          }
        },
      );
    } catch (e) {
      // En cas d'erreur, émettre quand même une valeur pour ne pas bloquer
      _onlineUsersController.add(_currentOnlineUsers);
    }
  }

  /// Arrête le tracking de présence
  Future<void> stopTracking() async {
    await _presenceChannel?.untrack();
    await _presenceChannel?.unsubscribe();
    _presenceChannel = null;
  }

  /// Met à jour la liste des utilisateurs en ligne depuis le channel
  void _updateOnlineUsersFromChannel() {
    if (_presenceChannel == null) return;

    try {
      final state = _presenceChannel!.presenceState();
      final onlineUserIds = <String>{};

      // presenceState() retourne List<SinglePresenceState>
      // Chaque SinglePresenceState a une propriété "presences" (List<Presence>)
      // Chaque Presence a un "payload" qui contient nos données trackées
      for (final singlePresenceState in state) {
        try {
          // Accéder à la liste des presences
          final dynamic presenceData = singlePresenceState;
          final presences = presenceData.presences as List<dynamic>?;

          if (presences == null) continue;

          // Pour chaque presence dans la liste
          for (final presence in presences) {
            try {
              // Accéder au payload
              final dynamic presenceObj = presence;
              final payload = presenceObj.payload as Map<String, dynamic>?;

              if (payload != null) {
                final userId = payload['user_id'] as String?;
                if (userId != null) {
                  onlineUserIds.add(userId);
                }
              }
            } catch (_) {
              // Ignorer cette presence si on ne peut pas la parser
              continue;
            }
          }
        } catch (_) {
          // Ignorer ce SinglePresenceState si on ne peut pas le parser
          continue;
        }
      }

      _currentOnlineUsers = onlineUserIds.toISet();
      _onlineUsersController.add(_currentOnlineUsers);
    } catch (e) {
      // Ignorer les erreurs de parsing
    }
  }

  /// Vérifie si un utilisateur est en ligne
  bool isUserOnline(String userId) {
    return _currentOnlineUsers.contains(userId);
  }

  /// Nettoie les ressources
  void dispose() {
    stopTracking();
    _onlineUsersController.close();
  }
}

/// Provider du service de présence
final presenceServiceProvider = Provider<PresenceService>((ref) {
  final service = PresenceService(Supabase.instance.client);
  ref.onDispose(service.dispose);
  return service;
});
