// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booked_wishes_realtime_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookedWishesRealtimeHash() =>
    r'04a41d82e9c12e9beba65a4ac253f0fbd6b208fa';

/// StreamProvider qui écoute en temps réel tous les wishs réservés
/// par l'utilisateur courant.
///
/// Se met à jour automatiquement quand :
/// - L'utilisateur réserve/annule une réservation (wish_taken_by_user)
/// - Un wish réservé est modifié/supprimé (wishs)
/// - Le nom d'une wishlist change (wishlists)
/// - Le pseudo/avatar du propriétaire change (profiles)
///
/// Copied from [bookedWishesRealtime].
@ProviderFor(bookedWishesRealtime)
final bookedWishesRealtimeProvider =
    AutoDisposeStreamProvider<IList<BookedWishWithDetails>>.internal(
  bookedWishesRealtime,
  name: r'bookedWishesRealtimeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bookedWishesRealtimeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BookedWishesRealtimeRef
    = AutoDisposeStreamProviderRef<IList<BookedWishWithDetails>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
