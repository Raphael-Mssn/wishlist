import 'dart:io';
import 'dart:typed_data';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_repository.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_repository_provider.dart';
import 'package:wishlist/shared/infra/utils/update_entity.dart';
import 'package:wishlist/shared/models/wish/create_request/wish_create_request.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

class WishService {
  WishService(this._wishRepository, this.ref);
  final WishRepository _wishRepository;
  final Ref ref;

  Future<IList<Wish>> getWishsFromWishlist(int wishlistId) async {
    return _wishRepository.getWishsFromWishlist(wishlistId);
  }

  Future<int> getNbWishsByUser(String userId) async {
    return _wishRepository.getNbWishsByUser(userId);
  }

  Future<Wish> createWish(WishCreateRequest wishCreateRequest) async {
    return _wishRepository.createWish(wishCreateRequest);
  }

  Future<Wish> updateWish(
    Wish wishToUpdate,
  ) async {
    return updateEntity(
      wishToUpdate,
      ref,
      _wishRepository.updateWish,
    );
  }

  Future<void> deleteWish(int wishId, {String? iconUrl}) async {
    // Supprimer l'image si elle existe (on laisse l'erreur remonter si ça échoue)
    if (iconUrl != null && iconUrl.isNotEmpty) {
      await _wishRepository.deleteWishImage(iconUrl);
    }

    // Supprimer le wish
    return _wishRepository.deleteWish(wishId);
  }

  Future<bool> hasWishesInWishlist(int wishlistId) async {
    final wishes = await getWishsFromWishlist(wishlistId);
    return wishes.isNotEmpty;
  }

  /// Crée un wish avec upload d'image optionnel
  Future<Wish> createWishWithImage({
    required WishCreateRequest wishCreateRequest,
    File? imageFile,
  }) async {
    // 1. Créer le wish d'abord (sans image)
    final createdWish = await _wishRepository.createWish(wishCreateRequest);

    // 2. Si une image est fournie, l'uploader et mettre à jour le wish
    if (imageFile != null) {
      // Upload de l'image (on laisse l'erreur remonter si ça échoue)
      final imagePath = await uploadWishImage(imageFile, createdWish.id);

      // Mise à jour du wish avec l'URL de l'image
      final updatedWish = await _wishRepository.updateWish(
        createdWish.copyWith(iconUrl: imagePath),
      );

      return updatedWish;
    }

    return createdWish;
  }

  /// Upload une image pour un wish
  Future<String> uploadWishImage(File imageFile, int wishId) async {
    // Compression de l'image
    final processedImageData = await _processImage(imageFile);

    // Utilisation d'un timestamp pour garantir un nom de fichier unique
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'wish_image_$timestamp.webp';

    // Upload de l'image via le repository
    final filePath = await _wishRepository.uploadWishImage(
      wishId: wishId,
      imageData: processedImageData,
      fileName: fileName,
    );

    return filePath;
  }

  /// Récupère l'URL publique d'une image de wish
  String getWishImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return '';
    }
    return _wishRepository.getWishImageUrl(imagePath);
  }

  /// Supprime une image de wish
  Future<void> deleteWishImage(String imagePath) async {
    if (imagePath.isNotEmpty) {
      await _wishRepository.deleteWishImage(imagePath);
    }
  }

  /// Compresse une image en WebP
  Future<Uint8List> _processImage(File imageFile) async {
    final compressedFile = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
      format: CompressFormat.webp,
      quality: 85,
      minWidth: 512,
      minHeight: 512,
    );

    if (compressedFile == null) {
      throw Exception('Failed to compress image');
    }

    return compressedFile;
  }
}

final wishServiceProvider = Provider(
  (ref) => WishService(
    ref.watch(wishRepositoryProvider),
    ref,
  ),
);
