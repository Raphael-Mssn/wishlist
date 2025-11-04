import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_stream_repository_provider.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

final watchWishsFromWishlistProvider =
    StreamProvider.autoDispose.family<IList<Wish>, int>((ref, wishlistId) {
  final repository = ref.watch(wishStreamRepositoryProvider);
  return repository.watchWishsFromWishlist(wishlistId);
});
