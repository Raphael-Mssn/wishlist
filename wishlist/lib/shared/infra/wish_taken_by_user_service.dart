import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/wish_taken_by_user.dart/wish_taken_by_user_repository.dart';
import 'package:wishlist/shared/infra/repositories/wish_taken_by_user.dart/wish_taken_by_user_repository_provider.dart';
import 'package:wishlist/shared/models/wish_taken_by_user/create_request/wish_taken_by_user_create_request.dart';

class WishTakenByUserService {
  WishTakenByUserService(this._wishTakenByUserRepository);
  final WishTakenByUserRepository _wishTakenByUserRepository;

  Future<void> wishTakenByUser(
    WishTakenByUserCreateRequest wishTakenByUser,
  ) async {
    return _wishTakenByUserRepository.wishTakenByUser(
      wishTakenByUser,
    );
  }
}

final wishTakenByUserServiceProvider = Provider(
  (ref) => WishTakenByUserService(ref.watch(wishTakenByUserRepositoryProvider)),
);
