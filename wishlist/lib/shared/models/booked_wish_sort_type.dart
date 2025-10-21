import 'package:flutter/material.dart';
import 'package:wishlist/l10n/l10n.dart';

enum BookedWishSortType {
  alphabetical,
  bookingCount,
}

enum SortOrder {
  ascending,
  descending,
}

class BookedWishSort {
  const BookedWishSort({
    required this.type,
    required this.order,
  });

  final BookedWishSortType type;
  final SortOrder order;

  BookedWishSort copyWith({
    BookedWishSortType? type,
    SortOrder? order,
  }) {
    return BookedWishSort(
      type: type ?? this.type,
      order: order ?? this.order,
    );
  }
}

extension BookedWishSortExtension on BookedWishSort {
  BookedWishSort toggleOrder() => copyWith(
        order: order == SortOrder.ascending
            ? SortOrder.descending
            : SortOrder.ascending,
      );

  IconData get icon {
    switch (order) {
      case SortOrder.ascending:
        return Icons.arrow_upward;
      case SortOrder.descending:
        return Icons.arrow_downward;
    }
  }
}

extension BookedWishSortTypeExtension on BookedWishSortType {
  String getLabel(AppLocalizations l10n) {
    switch (this) {
      case BookedWishSortType.alphabetical:
        return l10n.sortByAlphabetical;
      case BookedWishSortType.bookingCount:
        return l10n.sortByBookingCount;
    }
  }

  IconData get icon {
    switch (this) {
      case BookedWishSortType.alphabetical:
        return Icons.sort_by_alpha;
      case BookedWishSortType.bookingCount:
        return Icons.numbers;
    }
  }
}
