import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

enum WishlistStatsCardType {
  pending,
  booked,
}

class WishlistStatsCard extends StatelessWidget {
  const WishlistStatsCard({
    super.key,
    required this.type,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final WishlistStatsCardType type;
  final int count;
  final bool isSelected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected ? AppColors.makara : AppColors.gainsboro;

    final textColor = isSelected ? AppColors.gainsboro : AppColors.makara;

    const iconCircleSize = 40.0;

    final icon = type == WishlistStatsCardType.pending
        ? Icons.pending_actions_rounded
        : Icons.star_rounded;

    final l10n = context.l10n;

    final label = type == WishlistStatsCardType.pending
        ? l10n.wishlistStatusPending
        : l10n.wishlistStatusBooked;

    final borderRadius = BorderRadius.circular(20);

    return InkWell(
      borderRadius: borderRadius,
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(12).copyWith(right: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: iconCircleSize,
                  height: iconCircleSize,
                  decoration: BoxDecoration(
                    color: textColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: backgroundColor,
                  ),
                ),
                const Spacer(),
                Text(
                  count.toString(),
                  style: AppTextStyles.title.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
                ),
              ],
            ),
            const Gap(8),
            Text(
              label,
              style: AppTextStyles.smaller.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
