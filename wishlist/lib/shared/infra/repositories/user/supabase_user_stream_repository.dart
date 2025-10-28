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

  @override
  Stream<Profile?> watchProfileById(String userId) {
    final controller = StreamController<Profile?>.broadcast();

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

    // Cleanup quand le stream est fermé
    controller.onCancel = () {
      channel.unsubscribe();
      _channels.remove('profile_$userId');
    };

    _channels['profile_$userId'] = channel;

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

  @override
  Future<void> dispose() async {
    for (final channel in _channels.values) {
      await channel.unsubscribe();
    }
    _channels.clear();
  }
}
