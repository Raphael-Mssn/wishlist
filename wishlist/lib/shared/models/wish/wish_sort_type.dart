import 'package:flutter/material.dart';
import 'package:wishlist/l10n/l10n.dart';

enum WishSortType {
  favorite,
  alphabetical,
  price,
  createdAt,
}

enum SortOrder {
  ascending,
  descending,
}

class WishSort {
  const WishSort({
    required this.type,
    required this.order,
  });

  final WishSortType type;
  final SortOrder order;

  WishSort copyWith({
    WishSortType? type,
    SortOrder? order,
  }) {
    return WishSort(
      type: type ?? this.type,
      order: order ?? this.order,
    );
  }
}

extension WishSortTypeExtension on WishSortType {
  String getLabel(AppLocalizations l10n) {
    switch (this) {
      case WishSortType.favorite:
        return l10n.sortByFavorite;
      case WishSortType.alphabetical:
        return l10n.sortByAlphabetical;
      case WishSortType.price:
        return l10n.sortByPrice;
      case WishSortType.createdAt:
        return l10n.sortByDate;
    }
  }

  IconData get icon {
    switch (this) {
      case WishSortType.favorite:
        return Icons.favorite;
      case WishSortType.alphabetical:
        return Icons.sort_by_alpha;
      case WishSortType.price:
        return Icons.euro;
      case WishSortType.createdAt:
        return Icons.access_time;
    }
  }
}
