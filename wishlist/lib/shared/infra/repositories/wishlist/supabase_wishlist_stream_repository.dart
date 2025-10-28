import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_repository.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_stream_repository.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

class SupabaseWishlistStreamRepository implements WishlistStreamRepository {
  SupabaseWishlistStreamRepository(
    this._client,
    this._wishlistRepository,
  );

  final SupabaseClient _client;
  final WishlistRepository _wishlistRepository;
  static const _wishlistsTableName = 'wishlists';

  final Map<String, RealtimeChannel> _channels = {};
  final Map<String, StreamController<IList<Wishlist>>> _controllers = {};
  final Map<String, StreamController<Wishlist?>> _singleControllers = {};

  @override
  Stream<IList<Wishlist>> watchWishlistsByUser(String userId) {
    final key = 'user_$userId';

    // Si le stream existe déjà, le retourner
    // ignore: close_sinks - Le controller est déjà créé et sera fermé dans _cleanupStream
    final existingController = _controllers[key];
    if (existingController != null) {
      return existingController.stream;
    }

    // Créer un nouveau controller
    final controller = StreamController<IList<Wishlist>>.broadcast(
      onCancel: () => _cleanupStream(key),
    );
    _controllers[key] = controller;

    // Charger les données initiales
    _loadInitialWishlists(userId, controller);

    // Créer le channel Realtime
    final channel = _client
        .channel('wishlists_user_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: _wishlistsTableName,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id_owner',
            value: userId,
          ),
          callback: (payload) => _handleWishlistChange(userId, controller),
        )
        .subscribe();

    _channels[key] = channel;

    return controller.stream;
  }

  @override
  Stream<Wishlist?> watchWishlistById(int wishlistId) {
    final key = 'wishlist_$wishlistId';

    // Si le stream existe déjà, le retourner
    // ignore: close_sinks - Le controller est déjà créé et sera fermé dans _cleanupSingleStream
    final existingController = _singleControllers[key];
    if (existingController != null) {
      return existingController.stream;
    }

    // Créer un nouveau controller broadcast
    final controller = StreamController<Wishlist?>.broadcast(
      onCancel: () => _cleanupSingleStream(key),
    );
    _singleControllers[key] = controller;

    // Charger les données initiales
    _loadInitialWishlist(wishlistId, controller);

    // Créer le channel Realtime
    final channel = _client
        .channel('wishlist_$wishlistId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: _wishlistsTableName,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: wishlistId,
          ),
          callback: (payload) =>
              _handleSingleWishlistChange(wishlistId, controller, payload),
        )
        .subscribe();

    _channels[key] = channel;

    return controller.stream;
  }

  @override
  Stream<IList<Wishlist>> watchPublicWishlistsByUser(String userId) {
    final key = 'user_public_$userId';

    // Si le stream existe déjà, le retourner
    // ignore: close_sinks - Le controller est déjà créé et sera fermé dans _cleanupStream
    final existingController = _controllers[key];
    if (existingController != null) {
      return existingController.stream;
    }

    // Créer un nouveau controller
    final controller = StreamController<IList<Wishlist>>.broadcast(
      onCancel: () => _cleanupStream(key),
    );
    _controllers[key] = controller;

    // Charger les données initiales
    _loadInitialPublicWishlists(userId, controller);

    // Créer le channel Realtime
    // Note: Pour les wishlists publiques, on écoute tous les changements
    // de l'utilisateur et on filtre côté client
    final channel = _client
        .channel('wishlists_public_user_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: _wishlistsTableName,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id_owner',
            value: userId,
          ),
          callback: (payload) =>
              _handlePublicWishlistChange(userId, controller),
        )
        .subscribe();

    _channels[key] = channel;

    return controller.stream;
  }

  Future<void> _loadInitialWishlists(
    String userId,
    StreamController<IList<Wishlist>> controller,
  ) async {
    try {
      final wishlists = await _wishlistRepository.getWishlistsByUser(userId);
      if (!controller.isClosed) {
        controller.add(wishlists);
      }
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }

  Future<void> _loadInitialWishlist(
    int wishlistId,
    StreamController<Wishlist?> controller,
  ) async {
    try {
      final wishlist = await _wishlistRepository.getWishlistById(wishlistId);
      if (!controller.isClosed) {
        controller.add(wishlist);
      }
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }

  Future<void> _loadInitialPublicWishlists(
    String userId,
    StreamController<IList<Wishlist>> controller,
  ) async {
    try {
      final wishlists =
          await _wishlistRepository.getPublicWishlistsByUser(userId);
      if (!controller.isClosed) {
        controller.add(wishlists);
      }
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }

  Future<void> _handleWishlistChange(
    String userId,
    StreamController<IList<Wishlist>> controller,
  ) async {
    // Recharger toutes les wishlists de l'utilisateur
    try {
      final wishlists = await _wishlistRepository.getWishlistsByUser(userId);
      if (!controller.isClosed) {
        controller.add(wishlists);
      }
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }

  Future<void> _handlePublicWishlistChange(
    String userId,
    StreamController<IList<Wishlist>> controller,
  ) async {
    // Recharger toutes les wishlists publiques de l'utilisateur
    try {
      final wishlists =
          await _wishlistRepository.getPublicWishlistsByUser(userId);
      if (!controller.isClosed) {
        controller.add(wishlists);
      }
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }

  Future<void> _handleSingleWishlistChange(
    int wishlistId,
    StreamController<Wishlist?> controller,
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

      // Sinon, recharger la wishlist
      final wishlist = await _wishlistRepository.getWishlistById(wishlistId);
      if (!controller.isClosed) {
        controller.add(wishlist);
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

  void _cleanupSingleStream(String key) {
    _channels[key]?.unsubscribe();
    _channels.remove(key);
    _singleControllers[key]?.close();
    _singleControllers.remove(key);
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

    for (final controller in _singleControllers.values) {
      await controller.close();
    }
    _singleControllers.clear();
  }
}
