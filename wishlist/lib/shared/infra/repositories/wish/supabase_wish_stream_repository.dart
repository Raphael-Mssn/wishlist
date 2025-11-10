import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_repository.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_stream_repository.dart';
import 'package:wishlist/shared/models/booked_wish_with_details/booked_wish_with_details.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

class SupabaseWishStreamRepository implements WishStreamRepository {
  SupabaseWishStreamRepository(
    this._client,
    this._wishRepository,
  );

  final SupabaseClient _client;
  final WishRepository _wishRepository;
  static const _wishsTableName = 'wishs';
  static const _wishTakenByUserTableName = 'wish_taken_by_user';

  final Map<String, RealtimeChannel> _channels = {};
  final Map<String, StreamController<IList<Wish>>> _controllers = {};
  final Map<String, StreamController<IList<BookedWishWithDetails>>>
      _bookedWishControllers = {};

  @override
  Stream<IList<Wish>> watchWishsFromWishlist(int wishlistId) {
    final key = 'wishlist_$wishlistId';

    // ignore: close_sinks - Le controller est déjà créé et sera fermé dans _cleanupStream
    final existingController = _controllers[key];
    if (existingController != null) {
      return existingController.stream;
    }

    final controller = StreamController<IList<Wish>>.broadcast(
      onCancel: () => _cleanupStream(key),
    );
    _controllers[key] = controller;

    _loadInitialWishs(wishlistId, controller);

    final channel = _client
        .channel('wishs_wishlist_$wishlistId')
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

  Future<void> _handleWishChange(
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

  @override
  Stream<IList<BookedWishWithDetails>> watchBookedWishesByUser(String userId) {
    final key = 'booked_wishes_$userId';

    // ignore: close_sinks - Le controller est déjà créé et sera fermé dans _cleanupBookedWishStream
    final existingController = _bookedWishControllers[key];
    if (existingController != null) {
      return existingController.stream;
    }

    final controller = StreamController<IList<BookedWishWithDetails>>.broadcast(
      onCancel: () => _cleanupBookedWishStream(key),
    );
    _bookedWishControllers[key] = controller;

    _loadInitialBookedWishes(userId, controller);

    // Écouter les changements sur wish_taken_by_user (réservations)
    final channel = _client
        .channel('booked_wishes_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: _wishTakenByUserTableName,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) => _handleBookedWishChange(userId, controller),
        )
        // Écouter les changements sur la table wishs
        // (si un wish réservé est modifié/supprimé)
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: _wishsTableName,
          callback: (payload) => _handleBookedWishChange(userId, controller),
        )
        // Écouter les changements sur wishlists (si nom change)
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'wishlists',
          callback: (payload) => _handleBookedWishChange(userId, controller),
        )
        // Écouter les changements sur profiles (si pseudo/avatar change)
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'profiles',
          callback: (payload) => _handleBookedWishChange(userId, controller),
        )
        .subscribe();

    _channels[key] = channel;

    return controller.stream;
  }

  Future<void> _loadInitialBookedWishes(
    String userId,
    StreamController<IList<BookedWishWithDetails>> controller,
  ) async {
    try {
      final bookedWishes = await _wishRepository.getBookedWishesByUser(userId);
      if (!controller.isClosed) {
        controller.add(bookedWishes);
      }
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }

  Future<void> _handleBookedWishChange(
    String userId,
    StreamController<IList<BookedWishWithDetails>> controller,
  ) async {
    try {
      final bookedWishes = await _wishRepository.getBookedWishesByUser(userId);
      if (!controller.isClosed) {
        controller.add(bookedWishes);
      }
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }

  void _cleanupBookedWishStream(String key) {
    _channels[key]?.unsubscribe();
    _channels.remove(key);
    _bookedWishControllers[key]?.close();
    _bookedWishControllers.remove(key);
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

    for (final controller in _bookedWishControllers.values) {
      await controller.close();
    }
    _bookedWishControllers.clear();
  }
}
