import 'package:wishlist/shared/models/wish_taken_by_user/create_request/wish_taken_by_user_create_request.dart';

abstract class WishTakenByUserRepository {
  Future<void> wishTakenByUser(WishTakenByUserCreateRequest wishTakenByUser);
  Future<void> cancelWishTaken(int wishId);
}
