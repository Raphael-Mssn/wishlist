import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_repository.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_repository_provider.dart';
import 'package:wishlist/shared/models/wish/create_request/wish_create_request.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

class WishService {
  WishService(this._wishRepository);
  final WishRepository _wishRepository;

  Future<IList<Wish>> getWishsFromWishlist(int wishlistId) async {
    return _wishRepository.getWishsFromWishlist(wishlistId);
  }

  Future<Wish> createWish(WishCreateRequest wishCreateRequest) async {
    return _wishRepository.createWish(wishCreateRequest);
  }
}

final wishServiceProvider =
    Provider((ref) => WishService(ref.watch(wishRepositoryProvider)));
