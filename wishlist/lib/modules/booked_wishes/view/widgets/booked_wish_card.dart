import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/shared/models/booked_wish_with_details/booked_wish_with_details.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/utils/formatters.dart';
import 'package:wishlist/shared/widgets/wish_image_widget.dart';

class BookedWishCard extends ConsumerWidget {
  const BookedWishCard({
    super.key,
    required this.bookedWish,
    required this.onTap,
  });

  final BookedWishWithDetails bookedWish;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wish = bookedWish.wish;
    final price = wish.price;

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
                  WishImage(
                    iconUrl: wish.iconUrl,
                  ),
                  if (bookedWish.bookedQuantity > 1)
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      wish.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      bookedWish.wishlistName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.smaller.copyWith(
                        color: AppColors.makara,
                        fontWeight: FontWeight.normal,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              if (price != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    Formatters.currency(
                      price,
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
