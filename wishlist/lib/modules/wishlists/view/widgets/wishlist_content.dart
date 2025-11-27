import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:wishlist/gen/assets.gen.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wish_card.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_card.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/page_layout_empty/page_layout_empty_content.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/app_refresh_indicator.dart';
import 'package:wishlist/shared/widgets/animated_list_view.dart';

class WishlistContent extends StatelessWidget {
  const WishlistContent({
    super.key,
    required this.wishlist,
    required this.wishsToDisplay,
    required this.shouldDisplayWishs,
    required this.statCardSelected,
    required this.isWishsBookedHidden,
    required this.isMyWishlist,
    required this.onTapWish,
    required this.onAddWish,
    required this.onFavoriteToggle,
    required this.onRefresh,
    this.isSelectionMode = false,
    this.selectedWishIds = const {},
    this.onLongPressWish,
  });

  static const double _verticalPadding = 16;

  final Wishlist wishlist;
  final IList<Wish> wishsToDisplay;
  final bool shouldDisplayWishs;
  final WishlistStatsCardType statCardSelected;
  final bool isWishsBookedHidden;
  final bool isMyWishlist;
  final Function(
    BuildContext,
    Wish, {
    required bool isMyWishlist,
    required IList<Wish> wishsToDisplay,
    WishlistStatsCardType? cardType,
  }) onTapWish;
  final Function(BuildContext, Wishlist) onAddWish;
  final Function(Wish) onFavoriteToggle;
  final Future<void> Function() onRefresh;
  final bool isSelectionMode;
  final Set<int> selectedWishIds;
  final Function(int)? onLongPressWish;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final pageLayoutEmptyContentTitle =
        statCardSelected == WishlistStatsCardType.pending
            ? l10n.wishlistNoWish
            : isWishsBookedHidden
                ? l10n.wishlistNoWishBookedDisplayed
                : l10n.wishlistNoWishBooked;

    final shouldShowCallToAction = isMyWishlist &&
        (!isWishsBookedHidden ||
            statCardSelected == WishlistStatsCardType.pending);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: _verticalPadding,
        right: _verticalPadding,
        top: _verticalPadding,
      ),
      decoration: const BoxDecoration(
        color: AppColors.gainsboro,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return shouldDisplayWishs
              ? _WishList(
                  wishlist: wishlist,
                  wishsToDisplay: wishsToDisplay,
                  isMyWishlist: isMyWishlist,
                  statCardSelected: statCardSelected,
                  onTapWish: onTapWish,
                  onFavoriteToggle: onFavoriteToggle,
                  onRefresh: onRefresh,
                  isSelectionMode: isSelectionMode,
                  selectedWishIds: selectedWishIds,
                  onLongPressWish: onLongPressWish,
                )
              : _EmptyState(
                  constraints: constraints,
                  title: pageLayoutEmptyContentTitle,
                  shouldShowCallToAction: shouldShowCallToAction,
                  wishlist: wishlist,
                  onAddWish: onAddWish,
                );
        },
      ),
    );
  }
}

class _WishList extends StatelessWidget {
  const _WishList({
    required this.wishlist,
    required this.wishsToDisplay,
    required this.isMyWishlist,
    required this.statCardSelected,
    required this.onTapWish,
    required this.onFavoriteToggle,
    required this.onRefresh,
    this.isSelectionMode = false,
    this.selectedWishIds = const {},
    this.onLongPressWish,
  });

  static const double _bottomPadding = 120;
  static const double _itemSpacing = 8;

  final Wishlist wishlist;
  final IList<Wish> wishsToDisplay;
  final bool isMyWishlist;
  final WishlistStatsCardType statCardSelected;
  final Function(
    BuildContext,
    Wish, {
    required bool isMyWishlist,
    required IList<Wish> wishsToDisplay,
    WishlistStatsCardType? cardType,
  }) onTapWish;
  final Function(Wish) onFavoriteToggle;
  final Future<void> Function() onRefresh;
  final bool isSelectionMode;
  final Set<int> selectedWishIds;
  final Function(int)? onLongPressWish;

  @override
  Widget build(BuildContext context) {
    return AppRefreshIndicator(
      onRefresh: onRefresh,
      child: AnimatedListView<Wish>(
        items: wishsToDisplay.toList(),
        padding: const EdgeInsets.only(bottom: _WishList._bottomPadding),
        animationDuration: const Duration(milliseconds: 500),
        itemSpacing: _WishList._itemSpacing,
        itemEquality: (oldItem, newItem) => oldItem.id == newItem.id,
        itemBuilder: (context, wish, index) {
          return WishCard(
            wish: wish,
            onTap: () => onTapWish(
              context,
              wish,
              isMyWishlist: isMyWishlist,
              wishsToDisplay: wishsToDisplay,
              cardType: statCardSelected,
            ),
            onFavoriteToggle: () => onFavoriteToggle(wish),
            isMyWishlist: isMyWishlist,
            cardType: statCardSelected,
            onLongPress: onLongPressWish != null
                ? () => onLongPressWish!(wish.id)
                : null,
            isSelected: selectedWishIds.contains(wish.id),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.constraints,
    required this.title,
    required this.shouldShowCallToAction,
    required this.wishlist,
    required this.onAddWish,
  });

  static const double _topPadding = 16;
  static const double _illustrationHeightRatio = 0.5;

  final BoxConstraints constraints;
  final String title;
  final bool shouldShowCallToAction;
  final Wishlist wishlist;
  final Function(BuildContext, Wishlist) onAddWish;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.only(top: _topPadding),
      child: PageLayoutEmptyContent(
        illustrationUrl: Assets.svg.noWishlist,
        illustrationHeight: constraints.maxHeight * _illustrationHeightRatio,
        title: title,
        titleTextStyle: AppTextStyles.medium,
        callToAction: shouldShowCallToAction ? l10n.wishlistAddWish : null,
        onCallToAction:
            shouldShowCallToAction ? () => onAddWish(context, wishlist) : null,
      ),
    );
  }
}
