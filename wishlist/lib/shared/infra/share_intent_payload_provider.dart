import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:wishlist/shared/models/share_intent_payload/share_intent_payload.dart';
import 'package:wishlist/shared/models/wish_prefill_data/wish_prefill_data.dart';

part 'share_intent_payload_provider.g.dart';

/// **Flux (un seul consommateur par partage) :**
/// 1. **Écriture** : `ShareIntentHandler` appelle `setPayload` après avoir
///    traité l'intent, puis navigue vers add-wish.
/// 2. **Lecture prefill** : `AddWishScreen` appelle `getAndClearPrefill` une
///    fois au mount pour obtenir le prefill et l'effacer.
/// 3. **Lecture image** : `WishFormScreen` (mode création) lit `imagePath` pour
///    savoir s'il y avait une image, puis `clearImagePath` dans un
///    addPostFrameCallback pour consommer le chemin.
///
/// Avec singleTop sur Android, un second partage réutilise la même
/// activité ; le handler écrase le payload avant navigation.
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

  /// Consommé par AddWishScreen au mount. Retourne le prefill et le retire
  /// du state.
  WishPrefillData? getAndClearPrefill() {
    final p = state.prefill;
    state = ShareIntentPayload(imagePath: state.imagePath);
    return p;
  }

  /// Consommé par WishFormScreen après chargement de l'image. Retourne le
  /// chemin et le retire du state. À appeler hors des lifecycles (build,
  /// initState, etc.) — ex. dans addPostFrameCallback.
  String? getAndClearImagePath() {
    final path = state.imagePath;
    state = ShareIntentPayload(prefill: state.prefill);
    return path;
  }

  /// Efface uniquement le chemin image (sans le retourner). À appeler après
  /// le build.
  void clearImagePath() {
    if (state.imagePath == null) {
      return;
    }
    state = ShareIntentPayload(prefill: state.prefill);
  }
}
