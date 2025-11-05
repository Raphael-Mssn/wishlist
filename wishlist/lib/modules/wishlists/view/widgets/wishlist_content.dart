import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';
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

class WishlistContent extends ConsumerWidget {
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
    WishlistStatsCardType? cardType,
  }) onTapWish;
  final Function(BuildContext, Wishlist) onAddWish;
  final Function(Wish) onFavoriteToggle;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return Expanded(
      child: Container(
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
      ),
    );
  }
}

class _WishList extends ConsumerStatefulWidget {
  const _WishList({
    required this.wishlist,
    required this.wishsToDisplay,
    required this.isMyWishlist,
    required this.statCardSelected,
    required this.onTapWish,
    required this.onFavoriteToggle,
    required this.onRefresh,
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
    WishlistStatsCardType? cardType,
  }) onTapWish;
  final Function(Wish) onFavoriteToggle;
  final Future<void> Function() onRefresh;

  @override
  ConsumerState<_WishList> createState() => _WishListState();
}

class _WishListState extends ConsumerState<_WishList> {
  static const _staggeredAnimationDuration = 500;
  static const _staggeredAnimationDelay = 20;
  static const _staggeredAnimationMargin = 200;

  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _scheduleInitialLoadCompletion();
  }

  void _scheduleInitialLoadCompletion() {
    final totalDuration = _staggeredAnimationDuration +
        (widget.wishsToDisplay.length * _staggeredAnimationDelay) +
        _staggeredAnimationMargin;

    Future.delayed(Duration(milliseconds: totalDuration), () {
      if (mounted) {
        setState(() => _isInitialLoad = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppRefreshIndicator(
      onRefresh: widget.onRefresh,
      child: _isInitialLoad
          ? _buildStaggeredListView()
          : _buildImplicitlyAnimatedList(),
    );
  }

  // Animates the list when the wishs are loaded
  Widget _buildStaggeredListView() {
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: _WishList._bottomPadding),
        itemCount: widget.wishsToDisplay.length,
        itemBuilder: (context, index) {
          final wish = widget.wishsToDisplay[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: _staggeredAnimationDuration),
            child: SlideAnimation(
              verticalOffset: _staggeredAnimationDelay.toDouble(),
              child: FadeInAnimation(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: index < widget.wishsToDisplay.length - 1
                        ? _WishList._itemSpacing
                        : 0,
                  ),
                  child: WishCard(
                    wish: wish,
                    onTap: () => widget.onTapWish(
                      context,
                      wish,
                      isMyWishlist: widget.isMyWishlist,
                      cardType: widget.statCardSelected,
                    ),
                    onFavoriteToggle: () => widget.onFavoriteToggle(wish),
                    isMyWishlist: widget.isMyWishlist,
                    cardType: widget.statCardSelected,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Animates the list when the wishs are reordered
  Widget _buildImplicitlyAnimatedList() {
    return ImplicitlyAnimatedList<Wish>(
      padding: const EdgeInsets.only(bottom: _WishList._bottomPadding),
      itemData: widget.wishsToDisplay.toList(),
      itemEquality: (oldItem, newItem) => oldItem.id == newItem.id,
      initialAnimation: false,
      itemBuilder: (context, wish) {
        final index = widget.wishsToDisplay.indexOf(wish);
        return Padding(
          padding: EdgeInsets.only(
            bottom: index < widget.wishsToDisplay.length - 1
                ? _WishList._itemSpacing
                : 0,
          ),
          child: WishCard(
            wish: wish,
            onTap: () => widget.onTapWish(
              context,
              wish,
              isMyWishlist: widget.isMyWishlist,
              cardType: widget.statCardSelected,
            ),
            onFavoriteToggle: () => widget.onFavoriteToggle(wish),
            isMyWishlist: widget.isMyWishlist,
            cardType: widget.statCardSelected,
          ),
        );
      },
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
