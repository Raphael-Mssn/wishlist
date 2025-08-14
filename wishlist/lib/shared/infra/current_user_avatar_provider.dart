import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wishlist/shared/infra/avatar_service.dart';
import 'package:wishlist/shared/infra/user_service.dart';

class AvatarNotifier extends StateNotifier<AsyncValue<String?>> {
  AvatarNotifier(this._avatarService, this._userService)
      : super(const AsyncValue.loading()) {
    _loadCurrentUserAvatar();
  }

  final AvatarService _avatarService;
  final UserService _userService;

  Future<void> _loadCurrentUserAvatar() async {
    try {
      final currentUserId = _userService.getCurrentUserId();
      final appUser = await _userService.getAppUserById(currentUserId);
      final avatarUrl = appUser.profile.avatarUrl;

      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        final fullAvatarUrl = _avatarService.getAvatarUrl(avatarUrl);
        state = AsyncValue.data(fullAvatarUrl);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> pickAndUploadAvatar() async {
    try {
      state = const AsyncValue.loading();

      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image == null) {
        // Restauration de l'état précédent
        await _loadCurrentUserAvatar();
        return;
      }

      final imageFile = File(image.path);
      final avatarPath = await _avatarService.uploadAvatar(imageFile);
      final fullAvatarUrl = _avatarService.getAvatarUrl(avatarPath);

      state = AsyncValue.data(fullAvatarUrl);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> takePhotoAndUpload() async {
    try {
      state = const AsyncValue.loading();

      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image == null) {
        // Restauration de l'état précédent
        await _loadCurrentUserAvatar();
        return;
      }

      final imageFile = File(image.path);
      final avatarPath = await _avatarService.uploadAvatar(imageFile);
      final fullAvatarUrl = _avatarService.getAvatarUrl(avatarPath);

      state = AsyncValue.data(fullAvatarUrl);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteAvatar() async {
    try {
      state = const AsyncValue.loading();
      await _avatarService.deleteAvatar();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void refresh() {
    _loadCurrentUserAvatar();
  }
}

final currentUserAvatarProvider =
    StateNotifierProvider<AvatarNotifier, AsyncValue<String?>>((ref) {
  final avatarService = ref.watch(avatarServiceProvider);
  final userService = ref.watch(userServiceProvider);
  return AvatarNotifier(avatarService, userService);
});
