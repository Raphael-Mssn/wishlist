import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/non_null_extensions/go_true_client_non_null_getter_user_extension.dart';
import 'package:wishlist/shared/infra/repositories/friendship/friendship_repository.dart';
import 'package:wishlist/shared/infra/repositories/friendship/friendship_stream_repository.dart';

class SupabaseFriendshipStreamRepository implements FriendshipStreamRepository {
  SupabaseFriendshipStreamRepository(
    this._client,
    this._friendshipRepository,
  );

  final SupabaseClient _client;
  final FriendshipRepository _friendshipRepository;
  static const _friendshipsTableName = 'friendships';

  final Map<String, RealtimeChannel> _channels = {};
  final Map<String, StreamController<ISet<String>>> _controllers = {};

  StreamController<FriendshipIds>? _allFriendshipsController;

  @override
  Stream<FriendshipIds> watchCurrentUserAllFriendships() {
    final currentUserId = _client.auth.currentUserNonNull.id;
    final key = 'all_friendships_$currentUserId';

    final existingController = _allFriendshipsController;
    if (existingController != null) {
      return existingController.stream;
    }

    // ignore: close_sinks - Le controller sera fermé dans _cleanupAllFriendshipsStream
    final newController = StreamController<FriendshipIds>.broadcast(
      onCancel: _cleanupAllFriendshipsStream,
    );
    _allFriendshipsController = newController;

    _loadAllFriendships(currentUserId);

    final channel = _client
        .channel('friendships_all_$currentUserId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: _friendshipsTableName,
          callback: (payload) => _handleAllFriendshipsChange(currentUserId),
        )
        .subscribe();

    _channels[key] = channel;

    return newController.stream;
  }

  Future<void> _loadAllFriendships(String userId) async {
    try {
      final results = await Future.wait([
        _friendshipRepository.getFriendsIds(userId),
        _friendshipRepository.getCurrentUserPendingFriendsIds(),
        _friendshipRepository.getCurrentUserRequestedFriendsIds(),
      ]);

      final friendsIds = results[0];
      final pendingIds = results[1];
      final requestedIds = results[2];

      final allFriendshipsController = _allFriendshipsController;
      if (allFriendshipsController == null) {
        return;
      }

      if (!allFriendshipsController.isClosed) {
        allFriendshipsController.add(
          FriendshipIds(
            friendsIds: friendsIds,
            pendingIds: pendingIds,
            requestedIds: requestedIds,
          ),
        );
      }
    } catch (e) {
      final allFriendshipsController = _allFriendshipsController;
      if (allFriendshipsController == null) {
        return;
      }

      if (!allFriendshipsController.isClosed) {
        allFriendshipsController.addError(e);
      }
    }
  }

  void _handleAllFriendshipsChange(String userId) {
    _loadAllFriendships(userId);
  }

  void _cleanupAllFriendshipsStream() {
    final currentUserId = _client.auth.currentUserNonNull.id;
    final key = 'all_friendships_$currentUserId';
    _channels[key]?.unsubscribe();
    _channels.remove(key);
    _allFriendshipsController?.close();
    _allFriendshipsController = null;
  }

  @override
  Stream<ISet<String>> watchFriendsIds(String userId) {
    final key = 'friends_$userId';

    // ignore: close_sinks - Le controller est déjà créé et sera fermé dans _cleanupStream
    final existingController = _controllers[key];
    if (existingController != null) {
      return existingController.stream;
    }

    final controller = StreamController<ISet<String>>.broadcast(
      onCancel: () => _cleanupStream(key),
    );
    _controllers[key] = controller;

    _loadInitialFriends(userId, controller);

    final channel = _client
        .channel('friendships_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: _friendshipsTableName,
          callback: (payload) => _handleFriendshipChange(userId, controller),
        )
        .subscribe();

    _channels[key] = channel;

    return controller.stream;
  }

  @override
  Stream<ISet<String>> watchCurrentUserFriendsIds() {
    final currentUserId = _client.auth.currentUserNonNull.id;
    return watchFriendsIds(currentUserId);
  }

  @override
  Stream<ISet<String>> watchCurrentUserPendingFriendsIds() {
    final currentUserId = _client.auth.currentUserNonNull.id;
    final key = 'pending_$currentUserId';

    // ignore: close_sinks - Le controller est déjà créé et sera fermé dans _cleanupStream
    final existingController = _controllers[key];
    if (existingController != null) {
      return existingController.stream;
    }

    final controller = StreamController<ISet<String>>.broadcast(
      onCancel: () => _cleanupStream(key),
    );
    _controllers[key] = controller;

    _loadInitialPending(currentUserId, controller);

    final channel = _client
        .channel('friendships_pending_$currentUserId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: _friendshipsTableName,
          callback: (payload) =>
              _handlePendingChange(currentUserId, controller),
        )
        .subscribe();

    _channels[key] = channel;

    return controller.stream;
  }

  @override
  Stream<ISet<String>> watchCurrentUserRequestedFriendsIds() {
    final currentUserId = _client.auth.currentUserNonNull.id;
    final key = 'requested_$currentUserId';

    // ignore: close_sinks - Le controller est déjà créé et sera fermé dans _cleanupStream
    final existingController = _controllers[key];
    if (existingController != null) {
      return existingController.stream;
    }

    final controller = StreamController<ISet<String>>.broadcast(
      onCancel: () => _cleanupStream(key),
    );
    _controllers[key] = controller;

    _loadInitialRequested(currentUserId, controller);

    final channel = _client
        .channel('friendships_requested_$currentUserId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: _friendshipsTableName,
          callback: (payload) =>
              _handleRequestedChange(currentUserId, controller),
        )
        .subscribe();

    _channels[key] = channel;

    return controller.stream;
  }

  Future<void> _loadInitialFriends(
    String userId,
    StreamController<ISet<String>> controller,
  ) async {
    try {
      final friendsIds = await _friendshipRepository.getFriendsIds(userId);
      if (!controller.isClosed) {
        controller.add(friendsIds);
      }
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }

  Future<void> _loadInitialPending(
    String userId,
    StreamController<ISet<String>> controller,
  ) async {
    try {
      final pendingIds =
          await _friendshipRepository.getCurrentUserPendingFriendsIds();
      if (!controller.isClosed) {
        controller.add(pendingIds);
      }
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }

  Future<void> _loadInitialRequested(
    String userId,
    StreamController<ISet<String>> controller,
  ) async {
    try {
      final requestedIds =
          await _friendshipRepository.getCurrentUserRequestedFriendsIds();
      if (!controller.isClosed) {
        controller.add(requestedIds);
      }
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }

  Future<void> _handleFriendshipChange(
    String userId,
    StreamController<ISet<String>> controller,
  ) async {
    try {
      final friendsIds = await _friendshipRepository.getFriendsIds(userId);

      if (!controller.isClosed) {
        controller.add(friendsIds);
      }
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }

  Future<void> _handlePendingChange(
    String userId,
    StreamController<ISet<String>> controller,
  ) async {
    try {
      final pendingIds =
          await _friendshipRepository.getCurrentUserPendingFriendsIds();

      if (!controller.isClosed) {
        controller.add(pendingIds);
      }
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }

  Future<void> _handleRequestedChange(
    String userId,
    StreamController<ISet<String>> controller,
  ) async {
    try {
      final requestedIds =
          await _friendshipRepository.getCurrentUserRequestedFriendsIds();

      if (!controller.isClosed) {
        controller.add(requestedIds);
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
