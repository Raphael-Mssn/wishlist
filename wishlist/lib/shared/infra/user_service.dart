import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/user/user_repository.dart';
import 'package:wishlist/shared/infra/repositories/user/user_repository_provider.dart';
import 'package:wishlist/shared/models/app_user.dart';
import 'package:wishlist/shared/models/profile.dart';

class UserService {
  UserService(this._userRepository);
  final UserRepository _userRepository;

  String getCurrentUserEmail() {
    return _userRepository.getCurrentUserEmail();
  }

  Future<void> createUserProfile(Profile profile) async {
    return _userRepository.createUserProfile(profile);
  }

  Future<IList<AppUser>> searchUsersByEmailOrPseudo(String query) async {
    return _userRepository.searchUsersByEmailOrPseudo(query);
  }

  Future<AppUser> getAppUserById(String userId) async {
    return _userRepository.getAppUserById(userId);
  }
}

final userServiceProvider =
    Provider((ref) => UserService(ref.watch(userRepositoryProvider)));
