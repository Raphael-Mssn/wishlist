import 'dart:typed_data';

abstract class AvatarRepository {
  Future<String> uploadAvatar({
    required String userId,
    required Uint8List imageData,
    required String fileName,
  });

  Future<void> updateUserAvatarUrl({
    required String userId,
    required String? avatarUrl,
  });

  String getAvatarUrl(String avatarPath);

  Future<void> deleteAvatar(String avatarPath);
}
