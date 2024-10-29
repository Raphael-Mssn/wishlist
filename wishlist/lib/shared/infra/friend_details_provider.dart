import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/friendship_service.dart';
import 'package:wishlist/shared/models/friend_details/friend_details.dart';

class FriendDetailsNotifier extends StateNotifier<AsyncValue<FriendDetails>> {
  FriendDetailsNotifier(this._service, userId)
      : super(const AsyncValue.loading()) {
    loadFriendDetails(userId);
  }

  final FriendshipService _service;

  Future<void> loadFriendDetails(String userId) async {
    try {
      final friendDetails = await _service.getFriendDetails(userId);
      state = AsyncValue.data(friendDetails);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final friendDetailsProvider = StateNotifierProvider.family<
    FriendDetailsNotifier, AsyncValue<FriendDetails>, String>(
  (ref, userId) {
    final service = ref.read(friendshipServiceProvider);
    return FriendDetailsNotifier(service, userId);
  },
);
