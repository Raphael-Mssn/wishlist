import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wishlist/shared/infra/repositories/friendship/friendship_repository_provider.dart';
import 'package:wishlist/shared/infra/repositories/user/user_stream_repository_provider.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_stream_repository_provider.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/infra/wish_service.dart';
import 'package:wishlist/shared/infra/wishlist_service.dart';
import 'package:wishlist/shared/models/friend_details/friend_details.dart';

/// Provider Realtime pour les détails d'un ami
///
/// ✨ Écoute les changements en temps réel :
/// - Profil de l'ami
/// - Wishlists publiques de l'ami
final friendDetailsRealtimeProvider =
    StreamProvider.family.autoDispose<FriendDetails, String>((ref, userId) {
  final userStreamRepo = ref.watch(userStreamRepositoryProvider);
  final wishlistStreamRepo = ref.watch(wishlistStreamRepositoryProvider);
  final friendshipRepo = ref.watch(friendshipRepositoryProvider);
  final userService = ref.watch(userServiceProvider);
  final wishlistService = ref.watch(wishlistServiceProvider);
  final wishService = ref.watch(wishServiceProvider);

  // ✅ Écouter le profil ET les wishlists publiques en Realtime
  final profileStream = userStreamRepo.watchProfileById(userId);
  final publicWishlistsStream =
      wishlistStreamRepo.watchPublicWishlistsByUser(userId);

  return Rx.combineLatest2(
    profileStream,
    publicWishlistsStream,
    (profile, publicWishlists) async {
      if (profile == null) {
        throw Exception('Profile not found');
      }

      // Charger les autres données (pas encore en Realtime)
      try {
        // Charger l'AppUser complet (avec User et Profile)
        final appUser = await userService.getAppUserById(userId);

        // Charger les amis mutuels
        final mutualFriendsIds =
            await friendshipRepo.getMutualFriendsIds(userId);
        final mutualFriendsList = await Future.wait(
          mutualFriendsIds.map(userService.getAppUserById),
        );
        final mutualFriends = mutualFriendsList.toISet();

        final nbWishlists = await wishlistService.getNbWishlistsByUser(userId);
        final nbWishs = await wishService.getNbWishsByUser(userId);

        return FriendDetails(
          appUser: appUser,
          mutualFriends: mutualFriends,
          publicWishlists: publicWishlists,
          nbWishlists: nbWishlists,
          nbWishs: nbWishs,
        );
      } catch (e) {
        rethrow;
      }
    },
  ).asyncMap((future) => future);
});
