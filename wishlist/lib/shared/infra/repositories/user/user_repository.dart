import 'package:wishlist/shared/models/profile.dart';

abstract class UserRepository {
  String getCurrentUserEmail();
  Future<void> createUserProfile(Profile profile);
}
