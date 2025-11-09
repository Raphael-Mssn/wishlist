import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_streams_providers.dart';
import 'package:wishlist/shared/theme/theme.dart';
import 'package:wishlist/shared/theme/utils/get_wishlist_theme.dart';

/// Provider qui stocke le thème actuel par wishlistId (cache)
/// Permet de partager le thème entre WishlistScreen et ConsultWishScreen
final wishlistThemeCacheProvider =
    StateProvider.family<ThemeData?, int>((ref, wishlistId) => null);

/// Provider qui retourne TOUJOURS un thème (jamais null)
/// - Utilise le cache s'il existe
/// - Sinon, récupère la wishlist et génère le thème
/// - Sinon, retourne le thème par défaut
final wishlistThemeProvider = Provider.family<ThemeData, int>(
  (ref, wishlistId) {
    // 1. Vérifier le cache
    final cachedTheme = ref.watch(wishlistThemeCacheProvider(wishlistId));
    if (cachedTheme != null) {
      return cachedTheme;
    }

    // 2. Essayer de récupérer la wishlist et générer le thème
    final wishlistAsync = ref.watch(watchWishlistByIdProvider(wishlistId));
    return wishlistAsync.when(
      data: (wishlist) {
        // Générer le thème depuis la wishlist (sans context, on utilise le thème de base)
        // getWishlistTheme accepte BuildContext? donc null est valide
        return getWishlistTheme(null, wishlist);
      },
      loading: () => theme, // Thème par défaut pendant le chargement
      error: (_, __) => theme, // Thème par défaut en cas d'erreur
    );
  },
);
