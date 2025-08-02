import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/gen/assets.gen.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wish_card.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_card.dart';
import 'package:wishlist/shared/infra/wishs_from_wishlist_provider.dart';
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
  });

  static const double _verticalPadding = 16;
  static const double _controlsSpacing = 8;

  final Wishlist wishlist;
  final IList<Wish> wishsToDisplay;
  final bool shouldDisplayWishs;
  final WishlistStatsCardType statCardSelected;
  final bool isWishsBookedHidden;
  final bool isMyWishlist;
  final Function(BuildContext, Wish, {required bool isMyWishlist}) onTapWish;
  final Function(BuildContext, Wishlist) onAddWish;
  final Function(Wish) onFavoriteToggle;

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
        padding: const EdgeInsets.all(_verticalPadding),
        decoration: const BoxDecoration(
          color: AppColors.gainsboro,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return shouldDisplayWishs
                ? _buildWishList(context, ref)
                : _buildEmptyState(
                    context,
                    constraints,
                    pageLayoutEmptyContentTitle,
                    shouldShowCallToAction,
                  );
          },
        ),
      ),
    );
  }

  Widget _buildWishList(BuildContext context, WidgetRef ref) {
    return AppRefreshIndicator(
      onRefresh: () => ref
          .read(
            wishsFromWishlistProvider(wishlist.id).notifier,
          )
          .loadWishs(),
      child: ListView.separated(
        // Espace pour le bouton flottant
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: wishsToDisplay.length,
        separatorBuilder: (context, index) => const Gap(_controlsSpacing),
        itemBuilder: (context, index) {
          final wish = wishsToDisplay[index];
          return WishCard(
            key: ValueKey(wish.id),
            wish: wish,
            onTap: () => onTapWish(
              context,
              wish,
              isMyWishlist: isMyWishlist,
            ),
            onFavoriteToggle: () => onFavoriteToggle(wish),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    BoxConstraints constraints,
    String title,
    bool shouldShowCallToAction,
  ) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.only(top: _verticalPadding),
      child: PageLayoutEmptyContent(
        illustrationUrl: Assets.svg.noWishlist,
        illustrationHeight: constraints.maxHeight / 2,
        title: title,
        titleTextStyle: AppTextStyles.medium,
        callToAction: shouldShowCallToAction ? l10n.wishlistAddWish : null,
        onCallToAction:
            shouldShowCallToAction ? () => onAddWish(context, wishlist) : null,
      ),
    );
  }
}
