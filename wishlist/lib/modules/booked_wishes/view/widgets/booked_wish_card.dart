import 'package:currency_formatter/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/shared/models/booked_wish_with_details/booked_wish_with_details.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

class BookedWishCard extends StatelessWidget {
  const BookedWishCard({
    super.key,
    required this.bookedWish,
    required this.onTap,
  });

  final BookedWishWithDetails bookedWish;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final wish = bookedWish.wish;
    final price = wish.price;
    const iconDimension = 64.0;

    final borderRadius = BorderRadius.circular(24);

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: borderRadius,
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: iconDimension,
                    height: iconDimension,
                    decoration: BoxDecoration(
                      color: AppColors.gainsboro,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Text(
                      'x${bookedWish.bookedQuantity}',
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
                child: RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    children: [
                      TextSpan(text: wish.name),
                      TextSpan(
                        text: ' (${bookedWish.wishlistName})',
                        style: AppTextStyles.smaller.copyWith(
                          color: AppColors.makara,
                          fontWeight: FontWeight.normal,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (price != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    CurrencyFormatter.format(
                      price,
                      CurrencyFormat.eur,
                      showThousandSeparator: false,
                    ),
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.darkGrey,
                      height: 1,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
