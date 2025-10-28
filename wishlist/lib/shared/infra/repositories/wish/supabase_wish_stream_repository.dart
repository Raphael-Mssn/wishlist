import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_repository.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_stream_repository.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

class SupabaseWishStreamRepository implements WishStreamRepository {
  SupabaseWishStreamRepository(
    this._client,
    this._wishRepository,
  );

  final SupabaseClient _client;
  final WishRepository _wishRepository;
  static const _wishsTableName = 'wishs';

  final Map<String, RealtimeChannel> _channels = {};
  final Map<String, StreamController<IList<Wish>>> _controllers = {};

  @override
  Stream<IList<Wish>> watchWishsFromWishlist(int wishlistId) {
    final key = 'wishlist_$wishlistId';

    // Si le stream existe déjà, le retourner
    // ignore: close_sinks - Le controller est déjà créé et sera fermé dans _cleanupStream
    final existingController = _controllers[key];
    if (existingController != null) {
      return existingController.stream;
    }

    // Créer un nouveau controller
    final controller = StreamController<IList<Wish>>.broadcast(
      onCancel: () => _cleanupStream(key),
    );
    _controllers[key] = controller;

    // Charger les données initiales
    _loadInitialWishs(wishlistId, controller);

    // Créer le channel Realtime avec écoute sur wishs ET wish_taken_by_user
    final channel = _client
        .channel('wishs_wishlist_$wishlistId')
        // Écouter les changements sur la table wishs
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: _wishsTableName,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'wishlist_id',
            value: wishlistId,
          ),
          callback: (payload) => _handleWishChange(wishlistId, controller),
        )
        // Écouter aussi les changements sur wish_taken_by_user
        // pour mettre à jour les réservations en temps réel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'wish_taken_by_user',
          callback: (payload) {
            // Quand une réservation change, recharger tous les wishs
            // pour récupérer les données à jour avec le JOIN
            _handleWishChange(wishlistId, controller);
          },
        )
        .subscribe();

    _channels[key] = channel;

    return controller.stream;
  }

  @override
  Stream<Wish?> watchWishById(int wishId) {
    // Créer un nouveau controller broadcast pour chaque écoute
    final controller = StreamController<Wish?>.broadcast();

    // Charger les données initiales
    _loadInitialWish(wishId, controller);

    // Créer le channel Realtime
    final channel = _client
        .channel('wish_$wishId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: _wishsTableName,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: wishId,
          ),
          callback: (payload) =>
              _handleSingleWishChange(wishId, controller, payload),
        )
        .subscribe();

    // Cleanup quand le stream est fermé
    controller.onCancel = channel.unsubscribe;

    return controller.stream;
  }

  Future<void> _loadInitialWishs(
    int wishlistId,
    StreamController<IList<Wish>> controller,
  ) async {
    try {
      final wishs = await _wishRepository.getWishsFromWishlist(wishlistId);
      if (!controller.isClosed) {
        controller.add(wishs);
      }
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }

  Future<void> _loadInitialWish(
    int wishId,
    StreamController<Wish?> controller,
  ) async {
    try {
      // Note: Il faudrait ajouter une méthode getWishById dans WishRepository
      // Pour l'instant, on ne charge pas les données initiales
      // Le premier événement Realtime les fournira
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }

  Future<void> _handleWishChange(
    int wishlistId,
    StreamController<IList<Wish>> controller,
  ) async {
    // Recharger tous les wishs de la wishlist
    try {
      final wishs = await _wishRepository.getWishsFromWishlist(wishlistId);
      if (!controller.isClosed) {
        controller.add(wishs);
      }
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }

  Future<void> _handleSingleWishChange(
    int wishId,
    StreamController<Wish?> controller,
    PostgresChangePayload payload,
  ) async {
    try {
      // Si c'est une suppression, émettre null
      if (payload.eventType == PostgresChangeEvent.delete) {
        if (!controller.isClosed) {
          controller.add(null);
        }
        return;
      }

      // Sinon, parser les nouvelles données
      final wish = Wish.fromJson(payload.newRecord);
      if (!controller.isClosed) {
        controller.add(wish);
      }
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }

  void _cleanupStream(String key) {
    _channels[key]?.unsubscribe();
    _channels.remove(key);
    _controllers[key]?.close();
    _controllers.remove(key);
  }

  @override
  Future<void> dispose() async {
    for (final channel in _channels.values) {
      await channel.unsubscribe();
    }
    _channels.clear();

    for (final controller in _controllers.values) {
      await controller.close();
    }
    _controllers.clear();
  }
}
