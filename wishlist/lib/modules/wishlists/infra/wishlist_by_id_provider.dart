import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/wishlist_service.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

final wishlistByIdProvider =
    FutureProvider.family<Wishlist, int>((ref, wishlistId) async {
  final wishlistService = ref.read(wishlistServiceProvider);
  return wishlistService.getWishlistById(wishlistId);
});
