import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/wish_service.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

extension WishlistExtensions on Wishlist {
  Future<List<Wish>> getWishes(WidgetRef ref) async {
    final wishes = await ref.read(wishServiceProvider).getWishsFromWishlist(id);
    return wishes.toList();
  }

  Future<bool> hasWishes(WidgetRef ref) async {
    final wishes = await getWishes(ref);
    return wishes.isNotEmpty;
  }
}
