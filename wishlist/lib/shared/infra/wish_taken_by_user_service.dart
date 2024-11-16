import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/wish_taken_by_user.dart/wish_taken_by_user_repository.dart';
import 'package:wishlist/shared/infra/repositories/wish_taken_by_user.dart/wish_taken_by_user_repository_provider.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/infra/wishs_from_wishlist_provider.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/models/wish_taken_by_user/create_request/wish_taken_by_user_create_request.dart';

class WishTakenByUserService {
  WishTakenByUserService(this._wishTakenByUserRepository, this.ref);
  final WishTakenByUserRepository _wishTakenByUserRepository;
  final Ref ref;

  Future<void> wishTakenByUser(
    Wish wish,
  ) async {
    final currentUserId = ref.read(userServiceProvider).getCurrentUserId();

    final wishTakenByUserCreateRequest = WishTakenByUserCreateRequest(
      wishId: wish.id,
      userId: currentUserId,
      // TODO: Handle quantity
      quantity: 1,
    );

    await _wishTakenByUserRepository.createWishTakenByUser(
      wishTakenByUserCreateRequest,
    );

    await ref
        .read(wishsFromWishlistProvider(wish.wishlistId).notifier)
        .loadWishs();
  }

  Future<void> cancelWishTaken(Wish wish) async {
    await _wishTakenByUserRepository.cancelWishTaken(
      wish.id,
    );

    await ref
        .read(wishsFromWishlistProvider(wish.wishlistId).notifier)
        .loadWishs();
  }
}

final wishTakenByUserServiceProvider = Provider(
  (ref) =>
      WishTakenByUserService(ref.watch(wishTakenByUserRepositoryProvider), ref),
);
