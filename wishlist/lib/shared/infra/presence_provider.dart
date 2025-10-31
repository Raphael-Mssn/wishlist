import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/presence_service.dart';

/// StreamProvider qui écoute les utilisateurs en ligne en temps réel
final onlineUsersProvider = StreamProvider<ISet<String>>((ref) async* {
  final presenceService = ref.watch(presenceServiceProvider);

  // Émettre immédiatement la valeur actuelle pour éviter le loading
  yield presenceService.currentOnlineUsers;

  // Puis écouter les changements
  yield* presenceService.onlineUsersStream;
});

/// Provider qui vérifie si un utilisateur spécifique est en ligne
final isUserOnlineProvider = Provider.family<bool, String>((ref, userId) {
  final onlineUsersAsync = ref.watch(onlineUsersProvider);

  return onlineUsersAsync.when(
    data: (onlineUsers) => onlineUsers.contains(userId),
    loading: () => false,
    error: (_, __) => false,
  );
});
