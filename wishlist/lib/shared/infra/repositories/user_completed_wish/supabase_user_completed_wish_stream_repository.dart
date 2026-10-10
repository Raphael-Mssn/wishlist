import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/repositories/user_completed_wish/user_completed_wish_repository.dart';
import 'package:wishlist/shared/infra/repositories/user_completed_wish/user_completed_wish_stream_repository.dart';
import 'package:wishlist/shared/models/completed_wish_with_details/completed_wish_with_details.dart';

class SupabaseUserCompletedWishStreamRepository
    implements UserCompletedWishStreamRepository {
  SupabaseUserCompletedWishStreamRepository(
    this._client,
    this._repository,
  );

  final SupabaseClient _client;
  final UserCompletedWishRepository _repository;
  static const _tableName = 'user_completed_wishs';

  final Map<String, RealtimeChannel> _channels = {};
  final Map<String, StreamController<IList<CompletedWishWithDetails>>>
      _controllers = {};

  @override
  Stream<IList<CompletedWishWithDetails>> watchCompletedWishesByUser(
    String userId,
  ) {
    final key = 'completed_wishes_$userId';

    // ignore: close_sinks - fermé dans _cleanupStream
    final existingController = _controllers[key];
    if (existingController != null) {
      return existingController.stream;
    }

    // ignore: close_sinks
    final controller =
        StreamController<IList<CompletedWishWithDetails>>.broadcast(
      onCancel: () => _cleanupStream(key),
    );
    _controllers[key] = controller;

    _loadData(userId, controller);

    final channel = _client
        .channel('completed_wishes_$userId')
        // Changements sur user_completed_wishs filtrés par user_id
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: _tableName,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) => _loadData(userId, controller),
        )
        // Si un wish complété est modifié/supprimé
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'wishs',
          callback: (payload) => _loadData(userId, controller),
        )
        // Si la wishlist d'origine est renommée ou supprimée
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'wishlists',
          callback: (payload) => _loadData(userId, controller),
        )
        // Si le pseudo/avatar du propriétaire change
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'profiles',
          callback: (payload) => _loadData(userId, controller),
        )
        .subscribe();

    _channels[key] = channel;

    return controller.stream;
  }

  Future<void> _loadData(
    String userId,
    StreamController<IList<CompletedWishWithDetails>> controller,
  ) async {
    try {
      final completedWishes =
          await _repository.getCompletedWishesByUser(userId);
      if (!controller.isClosed) {
        controller.add(completedWishes);
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
  void dispose() {
    for (final channel in _channels.values) {
      channel.unsubscribe();
    }
    _channels.clear();

    for (final controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();
  }
}
