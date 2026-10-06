import 'package:flutter_test/flutter_test.dart';
import 'package:wishlist/shared/models/wishlist/create_request/wishlist_create_request.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

void main() {
  group('WishlistCreateRequest', () {
    const request = WishlistCreateRequest(
      name: 'Noël',
      idOwner: 'owner-id',
      color: '#FFFFFF',
      order: 0,
      updatedBy: 'owner-id',
    );

    test('creates public wishlists by default', () {
      expect(request.visibility, WishlistVisibility.public);
      expect(request.toJson()['visibility'], 'public');
    });

    test('serializes a private visibility', () {
      final privateRequest =
          request.copyWith(visibility: WishlistVisibility.private);

      expect(privateRequest.toJson()['visibility'], 'private');
    });
  });
}
