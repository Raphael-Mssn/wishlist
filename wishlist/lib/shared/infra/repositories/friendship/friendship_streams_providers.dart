import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/friendship/friendship_stream_repository_provider.dart';

/// Stream provider pour les IDs des amis d'un utilisateur en temps réel
///
/// Usage dans un widget:
/// ```dart
/// class MyWidget extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final friendsIdsAsync = ref.watch(
///       watchFriendsIdsProvider('user-id')
///     );
///
///     return friendsIdsAsync.when(
///       data: (friendsIds) => Text('${friendsIds.length} amis'),
///       loading: () => CircularProgressIndicator(),
///       error: (error, stack) => Text('Erreur: $error'),
///     );
///   }
/// }
/// ```
final watchFriendsIdsProvider =
    StreamProvider.autoDispose.family<ISet<String>, String>((ref, userId) {
  final repository = ref.watch(friendshipStreamRepositoryProvider);
  return repository.watchFriendsIds(userId);
});

/// Stream provider pour les IDs des amis de l'utilisateur courant en temps réel
final watchCurrentUserFriendsIdsProvider =
    StreamProvider.autoDispose<ISet<String>>((ref) {
  final repository = ref.watch(friendshipStreamRepositoryProvider);
  return repository.watchCurrentUserFriendsIds();
});

/// Stream provider pour les demandes d'amitié en attente (reçues) en temps réel
final watchCurrentUserPendingFriendsIdsProvider =
    StreamProvider.autoDispose<ISet<String>>((ref) {
  final repository = ref.watch(friendshipStreamRepositoryProvider);
  return repository.watchCurrentUserPendingFriendsIds();
});

/// Stream provider pour les demandes d'amitié envoyées en temps réel
final watchCurrentUserRequestedFriendsIdsProvider =
    StreamProvider.autoDispose<ISet<String>>((ref) {
  final repository = ref.watch(friendshipStreamRepositoryProvider);
  return repository.watchCurrentUserRequestedFriendsIds();
});
