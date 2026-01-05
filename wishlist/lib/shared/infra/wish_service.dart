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

  Future<Wish> getWishById(int wishId) async {
    return _wishRepository.getWishById(wishId);
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
    // Supprimer les images si elles existent (principale + miniature)
    if (iconUrl != null && iconUrl.isNotEmpty) {
      // Supprimer l'image principale
      await _wishRepository.deleteWishImage(iconUrl);

      // Supprimer la miniature
      final thumbnailPath = iconUrl.replaceAll('.webp', '_thumb.webp');
      try {
        await _wishRepository.deleteWishImage(thumbnailPath);
      } catch (e) {
        // Ignorer si la miniature n'existe pas (anciennes images)
      }
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

  /// Met à jour un wish avec gestion optionnelle de l'image
  /// - Si [imageFile] est fourni : upload de la nouvelle image
  /// - Si [deleteImage] est true : suppression de l'image existante
  /// - Sinon : mise à jour sans changement d'image
  Future<Wish> updateWishWithImage({
    required Wish wish,
    File? imageFile,
    bool deleteImage = false,
  }) async {
    final iconUrl = wish.iconUrl;

    if (deleteImage && imageFile == null) {
      // Supprimer l'image si elle existe
      if (iconUrl != null && iconUrl.isNotEmpty) {
        await _wishRepository.deleteWishImage(iconUrl);
        // Supprimer aussi la miniature
        final thumbnailPath = iconUrl.replaceAll('.webp', '_thumb.webp');
        await _wishRepository.deleteWishImage(thumbnailPath);
      }

      // Mise à jour du wish avec iconUrl vide (équivalent à null)
      final updatedWish = await _wishRepository.updateWish(
        wish.copyWith(iconUrl: ''),
      );

      return updatedWish;
    }

    if (imageFile != null) {
      // Supprimer l'ancienne image si elle existe
      if (iconUrl != null && iconUrl.isNotEmpty) {
        await _wishRepository.deleteWishImage(iconUrl);
        // Supprimer aussi la miniature
        final thumbnailPath = iconUrl.replaceAll('.webp', '_thumb.webp');
        await _wishRepository.deleteWishImage(thumbnailPath);
      }

      // Upload de la nouvelle image
      final imagePath = await uploadWishImage(imageFile, wish.id);

      // Mise à jour du wish avec la nouvelle URL
      final updatedWish = await _wishRepository.updateWish(
        wish.copyWith(iconUrl: imagePath),
      );

      return updatedWish;
    }

    return _wishRepository.updateWish(wish);
  }

  /// Upload une image pour un wish
  Future<String> uploadWishImage(File imageFile, int wishId) async {
    // Compression de l'image principale
    final processedImageData = await _processImage(imageFile);

    // Compression de la miniature
    final thumbnailData = await _processThumbnail(imageFile);

    // Utilisation d'un timestamp pour garantir un nom de fichier unique
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final baseName = 'wish_image_$timestamp';
    final fileName = '$baseName.webp';
    final thumbnailFileName = '${baseName}_thumb.webp';

    // Upload de l'image principale via le repository
    final filePath = await _wishRepository.uploadWishImage(
      wishId: wishId,
      imageData: processedImageData,
      fileName: fileName,
    );

    // Upload de la miniature
    await _wishRepository.uploadWishImage(
      wishId: wishId,
      imageData: thumbnailData,
      fileName: thumbnailFileName,
    );

    return filePath;
  }

  /// Récupère l'URL publique d'une image de wish
  String getWishImageUrl(String? imagePath, {bool thumbnail = false}) {
    if (imagePath == null || imagePath.isEmpty) {
      return '';
    }

    // Si on veut la miniature, on remplace .webp par _thumb.webp dans le path
    if (thumbnail) {
      // imagePath est du type: "wishId/wish_image_timestamp.webp"
      // On veut obtenir: "wishId/wish_image_timestamp_thumb.webp"
      final thumbnailPath = imagePath.replaceFirst('.webp', '_thumb.webp');
      return _wishRepository.getWishImageUrl(thumbnailPath);
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
      quality: 90,
      minWidth: 1024,
      minHeight: 1024,
    );

    if (compressedFile == null) {
      throw Exception('Failed to compress image');
    }

    return compressedFile;
  }

  /// Compresse une image en miniature (pour les listes)
  Future<Uint8List> _processThumbnail(File imageFile) async {
    final compressedFile = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
      format: CompressFormat.webp,
      quality: 80,
      minWidth: 256,
      minHeight: 256,
    );

    if (compressedFile == null) {
      throw Exception('Failed to compress thumbnail');
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
