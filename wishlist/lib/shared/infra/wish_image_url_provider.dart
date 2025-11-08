import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/wish_service.dart';

/// Provider qui retourne l'URL complète d'une image de wish à partir de
/// son path
/// Paramètres: (imagePath, thumbnail)
final wishImageUrlProvider =
    Provider.family<String, (String?, bool)>((ref, params) {
  final (imagePath, thumbnail) = params;
  return ref
      .watch(wishServiceProvider)
      .getWishImageUrl(imagePath, thumbnail: thumbnail);
});
