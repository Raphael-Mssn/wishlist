import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/friendships_realtime_provider.dart';
import 'package:wishlist/shared/models/friendship/friendship.dart';

/// Écoute les changements de friendships en temps réel et calcule
/// le statut de l'amitié avec l'utilisateur spécifié
final friendshipStatusProvider =
    Provider.family<AsyncValue<FriendshipStatus>, String>((ref, userId) {
  final friendshipsAsync = ref.watch(friendshipsRealtimeProvider);

  // Transformer l'AsyncValue<FriendsData> en AsyncValue<FriendshipStatus>
  return friendshipsAsync.when(
    loading: () {
      return const AsyncValue.loading();
    },
    error: (error, stack) {
      return AsyncValue.error(error, stack);
    },
    data: (friendsData) {
      // Vérifier dans quelle liste se trouve l'utilisateur
      final isFriend = friendsData.friends.any((u) => u.user.id == userId);
      if (isFriend) {
        return const AsyncValue.data(FriendshipStatus.accepted);
      }

      // Vérifier si c'est une demande que NOUS avons envoyée
      final isRequested =
          friendsData.requestedFriends.any((u) => u.user.id == userId);
      if (isRequested) {
        return const AsyncValue.data(FriendshipStatus.pending);
      }

      // Vérifier si c'est une demande que NOUS avons REÇUE
      final isPendingFromThem =
          friendsData.pendingFriends.any((u) => u.user.id == userId);
      if (isPendingFromThem) {
        return const AsyncValue.data(FriendshipStatus.pending);
      }

      return const AsyncValue.data(FriendshipStatus.none);
    },
  );
});
