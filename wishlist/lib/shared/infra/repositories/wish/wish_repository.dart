import 'dart:typed_data';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:wishlist/shared/models/wish/create_request/wish_create_request.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

abstract class WishRepository {
  Future<IList<Wish>> getWishsFromWishlist(int wishlistId);
  Future<int> getNbWishsByUser(String userId);
  Future<Wish> createWish(WishCreateRequest wishlist);
  Future<Wish> updateWish(Wish wish);
  Future<void> deleteWish(int wishId);

  // Gestion des images de wishs
  Future<String> uploadWishImage({
    required int wishId,
    required Uint8List imageData,
    required String fileName,
  });

  String getWishImageUrl(String imagePath);

  Future<void> deleteWishImage(String imagePath);
}
