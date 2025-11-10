import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/models/app_user.dart';

final currentUserProfileProvider =
    FutureProvider.autoDispose<AppUser>((ref) async {
  final userService = ref.watch(userServiceProvider);
  final currentUserId = userService.getCurrentUserId();

  return userService.getAppUserById(currentUserId);
});
