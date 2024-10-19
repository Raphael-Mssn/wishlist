import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/wishlist_service.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

final wishlistByIdProvider =
    FutureProvider.family<Wishlist, String>((ref, wishlistId) async {
  final wishlistService = ref.watch(wishlistServiceProvider);
  return wishlistService.getWishlistById(wishlistId);
});
