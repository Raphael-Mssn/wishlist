import 'package:currency_formatter/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/modules/wishs/view/widgets/edit_wish_bottom_sheet.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

class WishCard extends StatelessWidget {
  const WishCard({
    super.key,
    required this.wish,
    required this.wishlist,
  });

  final Wish wish;
  final Wishlist wishlist;

  void onTap(BuildContext context) {
    showEditWishBottomSheet(context, wish, wishlist);
  }

  @override
  Widget build(BuildContext context) {
    final price = wish.price;
    const iconDimension = 64.0;

    final borderRadius = BorderRadius.circular(24);

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () => onTap(context),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(24),
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
                      'x${wish.quantity}',
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
                            CurrencyFormatter.format(
                              price,
                              CurrencyFormat.eur,
                              showThousandSeparator: false,
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
      ),
    );
  }
}
