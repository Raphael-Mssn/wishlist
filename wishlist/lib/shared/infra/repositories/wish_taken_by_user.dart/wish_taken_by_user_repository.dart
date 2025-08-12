import 'package:wishlist/shared/models/wish_taken_by_user/create_request/wish_taken_by_user_create_request.dart';

abstract class WishTakenByUserRepository {
  Future<void> createWishTakenByUser(
    WishTakenByUserCreateRequest wishTakenByUser,
  );
  Future<void> updateWishTakenByUser({
    required int wishId,
    required String userId,
    required int newQuantity,
  });
  Future<void> cancelWishTaken(int wishId);
}
