import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_card.dart';
import 'package:wishlist/shared/models/wish/wish_sort_type.dart';
import 'package:wishlist/shared/utils/string_utils.dart';

part 'wishlist_screen_notifier.g.dart';

class WishlistScreenState {
  const WishlistScreenState({
    this.statCardSelected = WishlistStatsCardType.pending,
    this.wishSort = const WishSort(
      type: WishSortType.favorite,
      order: SortOrder.descending,
    ),
    this.searchQuery = '',
    this.isSelectionMode = false,
    this.selectedWishIds = const {},
  });

  final WishlistStatsCardType statCardSelected;
  final WishSort wishSort;
  final String searchQuery;
  final bool isSelectionMode;
  final Set<int> selectedWishIds;

  WishlistScreenState copyWith({
    WishlistStatsCardType? statCardSelected,
    WishSort? wishSort,
    String? searchQuery,
    bool? isSelectionMode,
    Set<int>? selectedWishIds,
  }) {
    return WishlistScreenState(
      statCardSelected: statCardSelected ?? this.statCardSelected,
      wishSort: wishSort ?? this.wishSort,
      searchQuery: searchQuery ?? this.searchQuery,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedWishIds: selectedWishIds ?? this.selectedWishIds,
    );
  }
}

@riverpod
class WishlistScreenNotifier extends _$WishlistScreenNotifier {
  late final TextEditingController searchController;
  late final FocusNode searchFocusNode;
  late final PageController pageController;

  @override
  WishlistScreenState build(int wishlistId) {
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    pageController = PageController();

    searchController.addListener(() {
      final normalized = normalizeString(searchController.text);
      if (state.searchQuery != normalized) {
        state = state.copyWith(searchQuery: normalized);
      }
    });

    ref.onDispose(() {
      searchController.dispose();
      searchFocusNode.dispose();
      pageController.dispose();
    });

    return const WishlistScreenState();
  }

  void selectStatCard(WishlistStatsCardType type) {
    state = state.copyWith(statCardSelected: type);
    pageController.animateToPage(
      type.index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onPageChanged(int index) {
    state = state.copyWith(
      statCardSelected: WishlistStatsCardType.values[index],
    );
  }

  void updateSort(WishSort sort) {
    state = state.copyWith(wishSort: sort);
  }

  void enableSelectionMode(int wishId) {
    state = state.copyWith(
      isSelectionMode: true,
      selectedWishIds: {...state.selectedWishIds, wishId},
    );
  }

  void toggleWishSelection(int wishId) {
    final newIds = {...state.selectedWishIds};
    if (newIds.contains(wishId)) {
      newIds.remove(wishId);
    } else {
      newIds.add(wishId);
    }
    state = state.copyWith(
      selectedWishIds: newIds,
      isSelectionMode: newIds.isNotEmpty,
    );
  }

  void exitSelectionMode() {
    state = state.copyWith(
      isSelectionMode: false,
      selectedWishIds: {},
    );
  }
}
