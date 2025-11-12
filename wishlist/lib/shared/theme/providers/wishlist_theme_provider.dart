import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_streams_providers.dart';
import 'package:wishlist/shared/theme/utils/get_wishlist_theme.dart';

/// Provider qui stocke le thème actuel par wishlistId (cache)
/// Permet de partager le thème entre WishlistScreen et ConsultWishScreen
final wishlistThemeCacheProvider =
    StateProvider.family<ThemeData?, int>((ref, wishlistId) => null);

/// Provider qui retourne un AsyncValue<ThemeData>
/// - Utilise le cache s'il existe
/// - Sinon, récupère la wishlist et génère le thème
/// - Reste en loading si la wishlist n'est pas disponible
final wishlistThemeProvider = Provider.family<AsyncValue<ThemeData>, int>(
  (ref, wishlistId) {
    // 1. Vérifier le cache
    final cachedTheme = ref.watch(wishlistThemeCacheProvider(wishlistId));
    if (cachedTheme != null) {
      return AsyncValue.data(cachedTheme);
    }

    // 2. Essayer de récupérer la wishlist et générer le thème
    final wishlistAsync = ref.watch(watchWishlistByIdProvider(wishlistId));
    return wishlistAsync.when(
      data: (wishlist) {
        // Générer le thème depuis la wishlist (sans context, on utilise le thème de base)
        // getWishlistTheme accepte BuildContext? donc null est valide
        return AsyncValue.data(getWishlistTheme(null, wishlist));
      },
      loading: () => const AsyncValue.loading(), // Reste en loading
      error: AsyncValue.error,
    );
  },
);
