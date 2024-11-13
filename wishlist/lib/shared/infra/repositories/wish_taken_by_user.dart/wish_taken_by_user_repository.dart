import 'package:wishlist/shared/models/wish_taken_by_user/wish_taken_by_user.dart';

abstract class WishTakenByUserRepository {
  Future<void> wishTakenByUser(WishTakenByUser wishTakenByUser);
}
