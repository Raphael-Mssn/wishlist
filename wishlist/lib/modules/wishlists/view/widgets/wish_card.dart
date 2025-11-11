import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_card.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/theme/colors.dart';
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
  });

  final Wish wish;
  final void Function() onTap;
  final void Function() onFavoriteToggle;
  final bool isMyWishlist;
  final WishlistStatsCardType cardType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final price = wish.price;
    final shouldDisplayFavouriteIcon =
        isMyWishlist || (!isMyWishlist && wish.isFavourite);

    final borderRadius = BorderRadius.circular(24);

    // Calculer la quantité à afficher selon le contexte
    final quantityToDisplay = _getQuantityToDisplay();

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Stack(
          children: [
            Ink(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      WishImage(
                        iconUrl: wish.iconUrl,
                      ),
                      if (quantityToDisplay > 1)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Text(
                            'x$quantityToDisplay',
                            style: AppTextStyles.small.copyWith(
                              color: AppColors.makara,
                              height: 1,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wish.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.small.copyWith(
                            color: AppColors.darkGrey,
                            height: 1,
                          ),
                        ),
                        const Gap(8),
                        if (price != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                Formatters.currency(
                                  price,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.small.copyWith(
                                  color: AppColors.darkGrey,
                                  height: 1,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
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
