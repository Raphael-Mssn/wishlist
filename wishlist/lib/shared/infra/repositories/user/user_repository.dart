import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:wishlist/shared/models/app_user.dart';
import 'package:wishlist/shared/models/profile.dart';

abstract class UserRepository {
  String getCurrentUserEmail();
  Future<void> createUserProfile(Profile profile);
  Future<IList<AppUser>> searchUsersByEmailOrPseudo(String query);
  Future<AppUser> getAppUserById(String userId);
}
