import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:wishlist/shared/models/share_intent_payload/share_intent_payload.dart';
import 'package:wishlist/shared/models/wish_prefill_data/wish_prefill_data.dart';

part 'share_intent_payload_provider.g.dart';

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
@Riverpod(keepAlive: true)
class ShareIntentPayloadNotifier extends _$ShareIntentPayloadNotifier {
  @override
  ShareIntentPayload build() => const ShareIntentPayload();

  /// Appelé par ShareIntentHandler après traitement de l'intent.
  void setPayload({
    WishPrefillData? prefill,
    String? imagePath,
  }) {
    state = ShareIntentPayload(prefill: prefill, imagePath: imagePath);
  }

  /// Consommé par AddWishScreen au mount : retourne le payload et le vide.
  /// À appeler hors des lifecycles (build, initState), ex. en post-frame.
  ShareIntentPayload consume() {
    final payload = state;
    state = const ShareIntentPayload();
    return payload;
  }
}
