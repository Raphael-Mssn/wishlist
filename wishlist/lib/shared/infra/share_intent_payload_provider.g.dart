// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_intent_payload_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shareIntentPayloadNotifierHash() =>
    r'7dd02e7a8ee4088306ba7247529d287d76e41439';

/// **Flux (un seul consommateur par partage) :**
/// 1. **Écriture** : [ShareIntentHandler] appelle [setPayload] après avoir
///    traité l'intent, puis navigue vers add-wish.
/// 2. **Lecture prefill** : [AddWishScreen] appelle [getAndClearPrefill] une
///    fois au mount pour obtenir le prefill et l'effacer.
/// 3. **Lecture image** : [WishFormScreen] (mode création) lit [imagePath] pour
///    savoir s'il y avait une image, puis [clearImagePath] dans un
///    addPostFrameCallback pour consommer le chemin.
///
/// Avec [singleTop] sur Android, un second partage réutilise la même
/// activité ; le handler écrase le payload avant navigation.
///
/// Copied from [ShareIntentPayloadNotifier].
@ProviderFor(ShareIntentPayloadNotifier)
final shareIntentPayloadNotifierProvider =
    NotifierProvider<ShareIntentPayloadNotifier, ShareIntentPayload>.internal(
  ShareIntentPayloadNotifier.new,
  name: r'shareIntentPayloadNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shareIntentPayloadNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ShareIntentPayloadNotifier = Notifier<ShareIntentPayload>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
