import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wishlist/shared/infra/repositories/user_completed_wish/user_completed_wish_stream_repository_provider.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/models/completed_wish_with_details/completed_wish_with_details.dart';

part 'completed_wishes_realtime_provider.g.dart';

/// StreamProvider qui écoute en temps réel tous les wishs complétés
/// par l'utilisateur courant.
///
/// Se met à jour automatiquement quand :
/// - L'utilisateur complète/dé-complète un wish (user_completed_wishs)
/// - Un wish complété est modifié/supprimé (wishs)
/// - La wishlist d'origine est renommée (wishlists)
/// - Le pseudo/avatar du propriétaire change (profiles)
@riverpod
Stream<IList<CompletedWishWithDetails>> completedWishesRealtime(
  Ref ref,
) {
  final userId = ref.watch(userServiceProvider).getCurrentUserId();
  final streamRepository = ref.watch(userCompletedWishStreamRepositoryProvider);

  return streamRepository.watchCompletedWishesByUser(userId);
}

/// StreamProvider paramétré pour les wishs complétés d'un autre utilisateur.
@riverpod
Stream<IList<CompletedWishWithDetails>> completedWishesByUserRealtime(
  Ref ref,
  String userId,
) {
  final streamRepository = ref.watch(userCompletedWishStreamRepositoryProvider);

  return streamRepository.watchCompletedWishesByUser(userId);
}
