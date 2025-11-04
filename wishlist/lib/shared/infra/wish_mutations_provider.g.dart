// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wish_mutations_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$createWishMutationHash() =>
    r'20f793cac9b7e918bb1615aca08d26b585971728';

/// Mutation pour créer un wish
///
/// Usage :
/// ```dart
/// await ref.read(createWishMutationProvider.notifier).createWish(request);
/// ```
///
/// Copied from [CreateWishMutation].
@ProviderFor(CreateWishMutation)
final createWishMutationProvider =
    AutoDisposeNotifierProvider<CreateWishMutation, AsyncUpdate<Wish>>.internal(
  CreateWishMutation.new,
  name: r'createWishMutationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createWishMutationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreateWishMutation = AutoDisposeNotifier<AsyncUpdate<Wish>>;
String _$updateWishMutationHash() =>
    r'e9c64a3a55c89fa182dd262477b39f6e9489a82b';

/// Mutation pour mettre à jour un wish
///
/// Copied from [UpdateWishMutation].
@ProviderFor(UpdateWishMutation)
final updateWishMutationProvider =
    AutoDisposeNotifierProvider<UpdateWishMutation, AsyncUpdate<Wish>>.internal(
  UpdateWishMutation.new,
  name: r'updateWishMutationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateWishMutationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UpdateWishMutation = AutoDisposeNotifier<AsyncUpdate<Wish>>;
String _$deleteWishMutationHash() =>
    r'8c9d2bb2f72f75887b8c92b7cca12dc78af8eadf';

/// Mutation pour supprimer un wish
///
/// Copied from [DeleteWishMutation].
@ProviderFor(DeleteWishMutation)
final deleteWishMutationProvider =
    AutoDisposeNotifierProvider<DeleteWishMutation, AsyncUpdate<void>>.internal(
  DeleteWishMutation.new,
  name: r'deleteWishMutationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deleteWishMutationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DeleteWishMutation = AutoDisposeNotifier<AsyncUpdate<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
