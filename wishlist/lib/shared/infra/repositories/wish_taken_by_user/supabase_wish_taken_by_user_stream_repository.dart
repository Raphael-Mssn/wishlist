import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/repositories/wish_taken_by_user/wish_taken_by_user_stream_repository.dart';
import 'package:wishlist/shared/models/wish_taken_by_user/wish_taken_by_user.dart';

class SupabaseWishTakenByUserStreamRepository
    implements WishTakenByUserStreamRepository {
  SupabaseWishTakenByUserStreamRepository(this._client);

  final SupabaseClient _client;
  static const _tableName = 'wish_taken_by_user';

  final Map<String, RealtimeChannel> _channels = {};
  final Map<String, StreamController<dynamic>> _controllers = {};

  @override
  Stream<IList<WishTakenByUser>> watchTakenByUsersForWish(int wishId) {
    final key = 'wish_$wishId';

    // ignore: close_sinks - Le controller est déjà créé et sera fermé dans dispose
    final existingController = _controllers[key];
    if (existingController != null) {
      return existingController.stream as Stream<IList<WishTakenByUser>>;
    }

    final controller = StreamController<IList<WishTakenByUser>>.broadcast();
    _controllers[key] = controller;

    // Fonction pour charger les données actuelles
    Future<void> loadData() async {
      try {
        final response = await _client
            .from(_tableName)
            .select()
            .eq('wish_id', wishId)
            .order('created_at');

        final data = (response as List)
            .map(
              (json) => WishTakenByUser.fromJson(json as Map<String, dynamic>),
            )
            .toIList();

        if (!controller.isClosed) {
          controller.add(data);
        }
      } catch (e) {
        if (!controller.isClosed) {
          controller.addError(e);
        }
      }
    }

    // Charger les données initiales
    loadData();

    // Créer le channel Realtime
    final channel =
        _client.channel('wish_taken_by_user_$key').onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: _tableName,
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'wish_id',
                value: wishId,
              ),
              callback: (payload) {
                // À chaque changement, recharger toutes les données
                loadData();
              },
            );

    channel.subscribe();
    _channels[key] = channel;

    return controller.stream;
  }

  @override
  Stream<IList<WishTakenByUser>> watchTakenByUser(String userId) {
    final key = 'user_$userId';

    // ignore: close_sinks - Le controller est déjà créé et sera fermé dans dispose
    final existingController = _controllers[key];
    if (existingController != null) {
      return existingController.stream as Stream<IList<WishTakenByUser>>;
    }

    final controller = StreamController<IList<WishTakenByUser>>.broadcast();
    _controllers[key] = controller;

    // Fonction pour charger les données actuelles
    Future<void> loadData() async {
      try {
        final response = await _client
            .from(_tableName)
            .select()
            .eq('user_id', userId)
            .order('created_at');

        final data = (response as List)
            .map(
              (json) => WishTakenByUser.fromJson(json as Map<String, dynamic>),
            )
            .toIList();

        if (!controller.isClosed) {
          controller.add(data);
        }
      } catch (e) {
        if (!controller.isClosed) {
          controller.addError(e);
        }
      }
    }

    // Charger les données initiales
    loadData();

    // Créer le channel Realtime
    final channel =
        _client.channel('wish_taken_by_user_$key').onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: _tableName,
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'user_id',
                value: userId,
              ),
              callback: (payload) {
                // À chaque changement, recharger toutes les données
                loadData();
              },
            );

    channel.subscribe();
    _channels[key] = channel;

    return controller.stream;
  }

  @override
  void dispose() {
    for (final channel in _channels.values) {
      _client.removeChannel(channel);
    }
    for (final controller in _controllers.values) {
      controller.close();
    }
    _channels.clear();
    _controllers.clear();
  }
}
