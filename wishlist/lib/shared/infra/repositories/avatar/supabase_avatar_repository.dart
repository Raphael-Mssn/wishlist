import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/repositories/avatar/avatar_repository.dart';
import 'package:wishlist/shared/infra/utils/execute_safely.dart';

class SupabaseAvatarRepository implements AvatarRepository {
  SupabaseAvatarRepository(this._client);

  final SupabaseClient _client;
  static const String _bucketName = 'avatars';
  static const String _profilesTableName = 'profiles';

  @override
  Future<String> uploadAvatar({
    required String userId,
    required Uint8List imageData,
    required String fileName,
  }) async {
    return executeSafely(
      () async {
        final filePath = '$userId/$fileName';

        try {
          await _client.storage
              .from(_bucketName)
              .uploadBinary(filePath, imageData);

          return filePath;
        } on StorageException catch (e) {
          // Si le fichier existe déjà (409), essayons avec upsert
          if (e.statusCode == '409') {
            await _client.storage.from(_bucketName).uploadBinary(
                  filePath,
                  imageData,
                  fileOptions: const FileOptions(upsert: true),
                );

            return filePath;
          }

          rethrow;
        }
      },
      errorMessage: 'Failed to upload avatar to bucket $_bucketName',
    );
  }

  @override
  Future<void> updateUserAvatarUrl({
    required String userId,
    required String? avatarUrl,
  }) async {
    return executeSafely(
      () async {
        await _client.from(_profilesTableName).update({
          'avatar_url': avatarUrl,
        }).eq('id', userId);
      },
      errorMessage: 'Failed to update user avatar URL',
    );
  }

  @override
  String getAvatarUrl(String avatarPath) {
    return _client.storage.from(_bucketName).getPublicUrl(avatarPath);
  }

  @override
  Future<void> deleteAvatar(String avatarPath) async {
    return executeSafely(
      () async {
        await _client.storage.from(_bucketName).remove([avatarPath]);
      },
      errorMessage: 'Failed to delete avatar',
    );
  }
}
