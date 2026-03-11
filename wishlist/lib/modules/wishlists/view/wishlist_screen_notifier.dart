import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wishlist/modules/wishlists/infra/wishlist_screen_data_realtime_provider.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_card.dart';
import 'package:wishlist/shared/infra/wish_mutations_provider.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/models/wish/wish_sort_type.dart';
import 'package:wishlist/shared/theme/providers/wishlist_theme_provider.dart';
import 'package:wishlist/shared/utils/string_utils.dart';

part 'wishlist_screen_notifier.freezed.dart';
part 'wishlist_screen_notifier.g.dart';

@freezed
class WishlistScreenState with _$WishlistScreenState {
  const factory WishlistScreenState({
    @Default(WishlistStatsCardType.pending)
    WishlistStatsCardType statCardSelected,
    @Default(
      WishSort(type: WishSortType.favorite, order: SortOrder.descending),
    )
    WishSort wishSort,
    @Default('') String searchQuery,
    @Default(false) bool isSelectionMode,
    @Default(<int>{}) Set<int> selectedWishIds,
  }) = _WishlistScreenState;
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

  Future<void> deleteSelectedWishs() async {
    final selectedIds = state.selectedWishIds;
    for (final wishId in selectedIds) {
      await ref.read(wishMutationsProvider.notifier).delete(wishId);
    }
    exitSelectionMode();
  }

  Future<void> moveSelectedWishs(int targetWishlistId) async {
    final selectedIds = state.selectedWishIds;
    for (final wishId in selectedIds) {
      await ref.read(wishMutationsProvider.notifier).moveToWishlist(
            wishId: wishId,
            targetWishlistId: targetWishlistId,
          );
    }
    exitSelectionMode();
  }

  Future<void> toggleFavorite(Wish wish) async {
    final updatedWish = wish.copyWith(isFavourite: !wish.isFavourite);
    await ref.read(wishMutationsProvider.notifier).update(updatedWish);
  }

  Future<void> refreshData() async {
    ref.invalidate(wishlistScreenDataRealtimeProvider(wishlistId));
    await Future.delayed(const Duration(milliseconds: 300));
  }

  void cacheWishlistTheme(int id, ThemeData theme) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(wishlistThemeCacheProvider(id).notifier).state = theme;
    });
  }
}
