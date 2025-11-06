import 'package:wishlist/shared/models/booked_wish_sort_type.dart';
import 'package:wishlist/shared/models/booked_wish_with_details/booked_wish_with_details.dart';
import 'package:wishlist/shared/utils/string_utils.dart';

/// Utilitaires pour le tri et le filtrage des booked wishes
class BookedWishSortUtils {
  BookedWishSortUtils._();

  /// Filtre et groupe les booked wishes par utilisateur
  static Map<String, List<BookedWishWithDetails>> filterAndGroupWishes(
    List<BookedWishWithDetails> bookedWishes, {
    required BookedWishSort sort,
    String searchQuery = '',
  }) {
    // Normaliser la query de recherche
    final normalizedQuery =
        searchQuery.isEmpty ? '' : normalizeString(searchQuery);

    // Filtrer par recherche
    final filtered = bookedWishes.where((bookedWish) {
      if (normalizedQuery.isEmpty) {
        return true;
      }

      final wishName = normalizeString(bookedWish.wish.name);
      final ownerPseudo = normalizeString(bookedWish.ownerPseudo);

      return wishName.contains(normalizedQuery) ||
          ownerPseudo.contains(normalizedQuery);
    }).toList();

    // Grouper par utilisateur
    final grouped = <String, List<BookedWishWithDetails>>{};
    for (final bookedWish in filtered) {
      grouped.putIfAbsent(bookedWish.ownerId, () => []).add(bookedWish);
    }

    // Trier les groupes
    final sortedEntries = grouped.entries.toList();

    switch (sort.type) {
      case BookedWishSortType.alphabetical:
        sortedEntries.sort((a, b) {
          final pseudo1 = normalizeString(a.value.first.ownerPseudo);
          final pseudo2 = normalizeString(b.value.first.ownerPseudo);
          return sort.order == SortOrder.ascending
              ? pseudo1.compareTo(pseudo2)
              : pseudo2.compareTo(pseudo1);
        });
      case BookedWishSortType.bookingCount:
        sortedEntries.sort((a, b) {
          final count1 = a.value.length;
          final count2 = b.value.length;
          return sort.order == SortOrder.ascending
              ? count1.compareTo(count2)
              : count2.compareTo(count1);
        });
    }

    return Map.fromEntries(sortedEntries);
  }
}
