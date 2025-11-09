import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/wish_service.dart';

/// Provider qui retourne l'URL complète d'une image de wish à partir de
/// son path
/// Paramètres: (imagePath: String?, thumbnail: bool)
final wishImageUrlProvider =
    Provider.family<String, ({String? imagePath, bool thumbnail})>(
        (ref, params) {
  return ref
      .watch(wishServiceProvider)
      .getWishImageUrl(params.imagePath, thumbnail: params.thumbnail);
});
