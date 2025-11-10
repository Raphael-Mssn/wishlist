import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/models/wish/wish_sort_type.dart';
import 'package:wishlist/shared/utils/string_utils.dart';

/// Utilitaires pour le tri et le filtrage des wishs
class WishSortUtils {
  WishSortUtils._();

  /// Trie et filtre une liste de wishs selon les critères donnés
  static IList<Wish> sortAndFilterWishs(
    IList<Wish> wishs, {
    required WishSort wishSort,
    String searchQuery = '',
  }) {
    // D'abord filtrer par recherche
    var filteredWishs = wishs;
    if (searchQuery.isNotEmpty) {
      final normalizedQuery = normalizeString(searchQuery);
      filteredWishs = wishs
          .where(
            (wish) => normalizeString(wish.name).contains(normalizedQuery),
          )
          .toIList();
    }

    // Puis trier
    return filteredWishs.sort((a, b) {
      var comparison = 0;

      switch (wishSort.type) {
        case WishSortType.favorite:
          comparison = _compareFavorite(a, b);

        case WishSortType.alphabetical:
          comparison = _compareAlphabetical(a, b);

        case WishSortType.price:
          comparison = _comparePrice(a, b, wishSort.order);

        case WishSortType.createdAt:
          comparison = _compareCreatedAt(a, b);
      }

      // Appliquer l'ordre de tri (sauf pour le prix et les favoris qui gèrent
      // déjà leur ordre)
      return wishSort.type == WishSortType.price ||
              wishSort.type == WishSortType.favorite
          ? comparison
          : (wishSort.order == SortOrder.ascending ? comparison : -comparison);
    }).toIList();
  }

  /// Compare deux wishs par favoris (favoris toujours en premier),
  /// puis par date de création (ordre fixe, pas d'inversion)
  static int _compareFavorite(Wish a, Wish b) {
    final comparison = (b.isFavourite ? 1 : 0).compareTo(a.isFavourite ? 1 : 0);
    if (comparison != 0) {
      return comparison;
    }
    return a.createdAt.compareTo(b.createdAt);
  }

  /// Compare deux wishs par ordre alphabétique (insensible à la casse)
  static int _compareAlphabetical(Wish a, Wish b) {
    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  }

  /// Compare deux wishs par prix (éléments sans prix toujours à la fin)
  static int _comparePrice(Wish a, Wish b, SortOrder order) {
    final priceA = a.price ?? 0;
    final priceB = b.price ?? 0;

    // Gestion spéciale pour les éléments sans prix (toujours à la fin)
    if (priceA == 0 && priceB == 0) {
      return 0;
    }
    if (priceA == 0) {
      return 1; // Élément A sans prix va à la fin
    }
    if (priceB == 0) {
      return -1; // Élément B sans prix va à la fin
    }

    // Tri normal pour les éléments avec prix
    final comparison = priceA.compareTo(priceB);
    return order == SortOrder.ascending ? comparison : -comparison;
  }

  /// Compare deux wishs par date de création
  static int _compareCreatedAt(Wish a, Wish b) {
    return a.createdAt.compareTo(b.createdAt);
  }
}
