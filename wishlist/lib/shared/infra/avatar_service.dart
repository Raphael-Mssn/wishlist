import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/avatar/avatar_repository.dart';
import 'package:wishlist/shared/infra/repositories/avatar/avatar_repository_provider.dart';
import 'package:wishlist/shared/infra/user_service.dart';

class AvatarService {
  AvatarService(this._avatarRepository, this.ref);

  final AvatarRepository _avatarRepository;
  final Ref ref;

  Future<String> uploadAvatar(File imageFile) async {
    final currentUserId = ref.read(userServiceProvider).getCurrentUserId();

    // Récupération de l'avatar existant
    String? existingAvatarPath;
    final currentUser =
        await ref.read(userServiceProvider).getAppUserById(currentUserId);
    existingAvatarPath = currentUser.profile.avatarUrl;

    // Compression de l'image
    final processedImageData = await _processImage(imageFile);

    // Utilisation d'un timestamp pour garantir un nom de fichier unique
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'avatar_$timestamp.webp';

    // Upload dans le storage
    final avatarPath = await _avatarRepository.uploadAvatar(
      userId: currentUserId,
      imageData: processedImageData,
      fileName: fileName,
    );

    // Mise à jour du profil utilisateur avec l'URL de l'avatar
    await _avatarRepository.updateUserAvatarUrl(
      userId: currentUserId,
      avatarUrl: avatarPath,
    );

    // Suppression de l'ancien avatar
    if (existingAvatarPath != null &&
        existingAvatarPath.isNotEmpty &&
        existingAvatarPath != avatarPath) {
      await _avatarRepository.deleteAvatar(existingAvatarPath);
    }

    return avatarPath;
  }

  String getAvatarUrl(String? avatarPath) {
    if (avatarPath == null || avatarPath.isEmpty) {
      return '';
    }

    // Si c'est déjà une URL complète, la retourner telle quelle
    if (avatarPath.startsWith('http')) {
      return avatarPath;
    }

    // Sinon, construire l'URL complète
    return _avatarRepository.getAvatarUrl(avatarPath);
  }

  Future<void> deleteAvatar() async {
    final currentUserId = ref.read(userServiceProvider).getCurrentUserId();

    // Récupération de l'avatar actuel
    final currentUser =
        await ref.read(userServiceProvider).getAppUserById(currentUserId);
    final currentAvatarPath = currentUser.profile.avatarUrl;

    if (currentAvatarPath != null && currentAvatarPath.isNotEmpty) {
      await _avatarRepository.deleteAvatar(currentAvatarPath);
    }

    // Mise à jour du profil utilisateur pour supprimer l'URL de l'avatar
    await _avatarRepository.updateUserAvatarUrl(
      userId: currentUserId,
      avatarUrl: null,
    );
  }

  Future<Uint8List> _processImage(File imageFile) async {
    // Compression en format WebP avec taille optimisée
    final compressedFile = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
      format: CompressFormat.webp,
      quality: 85,
      minWidth: 256,
      minHeight: 256,
      // Garde le ratio d'aspect et redimensionne si plus grand que 256x256
    );

    if (compressedFile == null) {
      throw Exception('Failed to compress image');
    }

    return compressedFile;
  }
}

final avatarServiceProvider =
    Provider((ref) => AvatarService(ref.watch(avatarRepositoryProvider), ref));
