import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_card.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/providers/wishlist_theme_provider.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/utils/formatters.dart';
import 'package:wishlist/shared/widgets/wish_image.dart';

class WishCard extends ConsumerWidget {
  const WishCard({
    super.key,
    required this.wish,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.isMyWishlist,
    required this.cardType,
    this.subtitle,
    this.quantityOverride,
    this.onLongPress,
    this.isSelected = false,
  });

  static const double _cardPadding = 12;
  static const double _selectionBorderWidth = 3;
  static const int _wishImageSize = 64;

  final Wish wish;
  final void Function() onTap;
  final void Function() onFavoriteToggle;
  final bool isMyWishlist;
  final WishlistStatsCardType cardType;
  final String? subtitle;
  final int? quantityOverride;
  final VoidCallback? onLongPress;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistThemeAsync =
        ref.watch(wishlistThemeProvider(wish.wishlistId));

    return wishlistThemeAsync.when(
      data: (wishlistTheme) => _buildCard(context, wishlistTheme.primaryColor),
      loading: () => _buildCard(context, AppColors.primary),
      error: (_, __) => _buildCard(context, AppColors.primary),
    );
  }

  Widget _buildCard(BuildContext context, Color selectionColor) {
    final price = wish.price;
    final subtitle = this.subtitle;
    final hasSubtitle = subtitle != null && subtitle.isNotEmpty;
    final hasPrice = price != null;
    final shouldDisplayFavouriteIcon =
        isMyWishlist || (!isMyWishlist && wish.isFavourite);

    final borderRadius = BorderRadius.circular(24);

    // Calculer la quantité à afficher selon le contexte
    final quantityToDisplay = quantityOverride ?? _getQuantityToDisplay();

    final cardPadding =
        isSelected ? _cardPadding - _selectionBorderWidth : _cardPadding;

    // Hauteur maximale = taille de l'image + padding (haut et bas)
    final maxHeight = _wishImageSize.toDouble() + (cardPadding * 2);

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        onLongPress: onLongPress,
        child: Stack(
          children: [
            SizedBox(
              height: maxHeight,
              child: Ink(
                padding: EdgeInsets.all(cardPadding),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(24),
                  border: isSelected
                      ? Border.all(
                          color: selectionColor,
                          width: _selectionBorderWidth,
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        WishImage(
                          iconUrl: wish.iconUrl,
                          size: _wishImageSize.toDouble(),
                        ),
                        if (quantityToDisplay > 1)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                                border: Border(
                                  bottom: BorderSide(
                                    color:
                                        AppColors.makara.withValues(alpha: 0.2),
                                  ),
                                  right: BorderSide(
                                    color:
                                        AppColors.makara.withValues(alpha: 0.2),
                                  ),
                                ),
                                boxShadow: [
                                  // shadow only on left side
                                  BoxShadow(
                                    color:
                                        AppColors.makara.withValues(alpha: 0.2),
                                    blurRadius: 3,
                                    offset: const Offset(-3, 0),
                                  ),
                                ],
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'x',
                                      style: AppTextStyles.smallest.copyWith(
                                        color: AppColors.makara,
                                        fontWeight: FontWeight.bold,
                                        height: 1,
                                      ),
                                    ),
                                    TextSpan(
                                      text: quantityToDisplay.toString(),
                                      style: AppTextStyles.smaller.copyWith(
                                        color: AppColors.makara,
                                        fontWeight: FontWeight.bold,
                                        height: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text(
                              wish.name,
                              maxLines: hasSubtitle ? 2 : 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.smaller.copyWith(
                                color: AppColors.darkGrey,
                                fontWeight: hasSubtitle
                                    ? FontWeight.normal
                                    : FontWeight.normal,
                                height: 1,
                              ),
                            ),
                          ),
                          if (hasSubtitle || hasPrice) ...[
                            if (hasSubtitle)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      subtitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.smallest.copyWith(
                                        color: AppColors.makara,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  if (hasPrice) ...[
                                    const Gap(8),
                                    Text(
                                      Formatters.currency(price),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.smaller.copyWith(
                                        color: AppColors.darkGrey,
                                        height: 1,
                                      ),
                                    ),
                                  ],
                                ],
                              )
                            else if (hasPrice)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    Formatters.currency(price),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.smaller.copyWith(
                                      color: AppColors.darkGrey,
                                      height: 1,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                top: 8,
                left: 8,
                child: _SelectionCheckIcon(color: selectionColor),
              ),
            if (shouldDisplayFavouriteIcon)
              Positioned(
                top: 4,
                right: 4,
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: isMyWishlist ? onFavoriteToggle : null,
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      child: Icon(
                        wish.isFavourite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: wish.isFavourite
                            ? AppColors.favorite
                            : AppColors.makara,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  int _getQuantityToDisplay() {
    switch (cardType) {
      case WishlistStatsCardType.pending:
        return wish.availableQuantity;
      case WishlistStatsCardType.booked:
        return wish.totalBookedQuantity;
    }
  }
}

class _SelectionCheckIcon extends StatelessWidget {
  const _SelectionCheckIcon({
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.background,
          width: 2,
        ),
      ),
      child: const Icon(
        Icons.check,
        color: AppColors.background,
        size: 16,
      ),
    );
  }
}
