import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/non_null_extensions/go_true_client_non_null_getter_user_extension.dart';
import 'package:wishlist/shared/infra/repositories/user/user_stream_repository.dart';
import 'package:wishlist/shared/models/profile.dart';

class SupabaseUserStreamRepository implements UserStreamRepository {
  SupabaseUserStreamRepository(this._client);

  final SupabaseClient _client;
  static const _profilesTableName = 'profiles';

  final Map<String, RealtimeChannel> _channels = {};
  final Map<String, StreamController<Profile?>> _controllers = {};

  @override
  Stream<Profile?> watchProfileById(String userId) {
    final key = 'profile_$userId';

    // Si le stream existe déjà, le retourner
    // ignore: close_sinks - Le controller est déjà créé et sera fermé dans _cleanupStream
    final existingController = _controllers[key];
    if (existingController != null) {
      return existingController.stream;
    }

    // Créer un nouveau controller broadcast
    final controller = StreamController<Profile?>.broadcast(
      onCancel: () => _cleanupStream(key),
    );
    _controllers[key] = controller;

    // Charger les données initiales
    _loadInitialProfile(userId, controller);

    // Créer le channel Realtime
    final channel = _client
        .channel('profile_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: _profilesTableName,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: userId,
          ),
          callback: (payload) =>
              _handleProfileChange(userId, controller, payload),
        )
        .subscribe();

    _channels[key] = channel;

    return controller.stream;
  }

  @override
  Stream<Profile?> watchCurrentUserProfile() {
    final currentUserId = _client.auth.currentUserNonNull.id;
    return watchProfileById(currentUserId);
  }

  Future<void> _loadInitialProfile(
    String userId,
    StreamController<Profile?> controller,
  ) async {
    try {
      final response = await _client
          .from(_profilesTableName)
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response != null && !controller.isClosed) {
        controller.add(Profile.fromJson(response));
      } else if (!controller.isClosed) {
        controller.add(null);
      }
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }

  Future<void> _handleProfileChange(
    String userId,
    StreamController<Profile?> controller,
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
      final profile = Profile.fromJson(payload.newRecord);
      if (!controller.isClosed) {
        controller.add(profile);
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
