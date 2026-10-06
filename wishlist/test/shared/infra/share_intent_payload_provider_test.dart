import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishlist/shared/infra/share_intent_payload_provider.dart';
import 'package:wishlist/shared/models/share_intent_payload/share_intent_payload.dart';
import 'package:wishlist/shared/models/wish_prefill_data/wish_prefill_data.dart';

void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  ShareIntentPayloadNotifier notifier() =>
      container.read(shareIntentPayloadNotifierProvider.notifier);

  test('consume returns the prefill and the image together', () {
    const prefill = WishPrefillData(name: 'Tente', linkUrl: 'https://x.fr');
    notifier().setPayload(prefill: prefill, imagePath: '/tmp/share.jpg');

    final payload = notifier().consume();

    expect(payload.prefill, prefill);
    expect(payload.imagePath, '/tmp/share.jpg');
  });

  test('consume empties the payload, image included', () {
    notifier().setPayload(imagePath: '/tmp/share.jpg');

    notifier().consume();

    expect(
      container.read(shareIntentPayloadNotifierProvider),
      const ShareIntentPayload(),
    );
    expect(notifier().consume().imagePath, isNull);
  });
}
