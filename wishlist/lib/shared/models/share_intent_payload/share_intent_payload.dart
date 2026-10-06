import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:wishlist/shared/models/wish_prefill_data/wish_prefill_data.dart';

part 'share_intent_payload.freezed.dart';

/// Payload reçu via share intent : prefill (titre, lien, etc.) et chemin vers
/// l'image partagée si l'app source en envoie une.
@freezed
class ShareIntentPayload with _$ShareIntentPayload {
  const factory ShareIntentPayload({
    WishPrefillData? prefill,
    String? imagePath,
  }) = _ShareIntentPayload;
}
