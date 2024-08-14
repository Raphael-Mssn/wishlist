import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/user/user_repository.dart';
import 'package:wishlist/shared/infra/repositories/user/user_repository_provider.dart';
import 'package:wishlist/shared/models/profile.dart';

class UserApi {
  UserApi(this._userRepository);
  final UserRepository _userRepository;

  String getCurrentUserEmail() {
    return _userRepository.getCurrentUserEmail();
  }

  Future<void> createUserProfile(Profile profile) async {
    return _userRepository.createUserProfile(profile);
  }
}

final userApiProvider =
    Provider((ref) => UserApi(ref.watch(userRepositoryProvider)));
