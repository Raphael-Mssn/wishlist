// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_intent_payload_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shareIntentPayloadNotifierHash() =>
    r'954ad0b36a2b6049bb501dd8d61bff9c24e4f3d8';

/// **Flux (un seul consommateur par partage) :**
/// 1. **Écriture** : `ShareIntentHandler` appelle `setPayload` après avoir
///    traité l'intent, puis navigue vers add-wish.
/// 2. **Lecture** : `AddWishScreen` appelle `consume` une fois au mount. Le
///    payload entier (prefill et image) est vidé immédiatement : rien ne reste
///    en mémoire si l'utilisateur n'atteint pas le formulaire. L'image est
///    ensuite transmise au formulaire par la route (`$extra`), pas par ce
///    provider.
///
/// Sur Android, un second partage est livré à l'activité existante
/// (ShareReceiverActivity → onNewIntent) ; le handler écrase le payload avant
/// navigation.
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
