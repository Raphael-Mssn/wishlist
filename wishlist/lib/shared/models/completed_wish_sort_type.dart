import 'package:flutter/material.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/models/wish/wish_sort_type.dart';

enum CompletedWishSortType {
  alphabetical,
  completedAt,
}

class CompletedWishSort {
  const CompletedWishSort({
    required this.type,
    required this.order,
  });

  final CompletedWishSortType type;
  final SortOrder order;

  CompletedWishSort copyWith({
    CompletedWishSortType? type,
    SortOrder? order,
  }) {
    return CompletedWishSort(
      type: type ?? this.type,
      order: order ?? this.order,
    );
  }
}

extension CompletedWishSortExtension on CompletedWishSort {
  CompletedWishSort toggleOrder() => copyWith(
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

extension CompletedWishSortTypeExtension on CompletedWishSortType {
  String getLabel(AppLocalizations l10n) {
    switch (this) {
      case CompletedWishSortType.alphabetical:
        return l10n.sortByAlphabetical;
      case CompletedWishSortType.completedAt:
        return l10n.sortByCompletedAt;
    }
  }

  IconData get icon {
    switch (this) {
      case CompletedWishSortType.alphabetical:
        return Icons.sort_by_alpha;
      case CompletedWishSortType.completedAt:
        return Icons.calendar_today;
    }
  }
}
