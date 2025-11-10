import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_stream_repository_provider.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/models/booked_wish_with_details/booked_wish_with_details.dart';

part 'booked_wishes_realtime_provider.g.dart';

/// StreamProvider qui écoute en temps réel tous les wishs réservés
/// par l'utilisateur courant.
///
/// Se met à jour automatiquement quand :
/// - L'utilisateur réserve/annule une réservation (wish_taken_by_user)
/// - Un wish réservé est modifié/supprimé (wishs)
/// - Le nom d'une wishlist change (wishlists)
/// - Le pseudo/avatar du propriétaire change (profiles)
@riverpod
Stream<IList<BookedWishWithDetails>> bookedWishesRealtime(
  Ref ref,
) {
  final userId = ref.watch(userServiceProvider).getCurrentUserId();
  final streamRepository = ref.watch(wishStreamRepositoryProvider);

  return streamRepository.watchBookedWishesByUser(userId);
}
