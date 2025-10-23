import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_card.dart';

class WishlistStatsSection extends StatelessWidget {
  const WishlistStatsSection({
    super.key,
    required this.statCardSelected,
    required this.nbWishsTotal,
    required this.nbWishsPending,
    required this.nbWishsBooked,
    required this.isWishsBookedHidden,
    required this.onTapStatCard,
  });

  final WishlistStatsCardType statCardSelected;
  final int nbWishsTotal;
  final int nbWishsPending;
  final int nbWishsBooked;
  final bool isWishsBookedHidden;
  final Function(WishlistStatsCardType) onTapStatCard;

  @override
  Widget build(BuildContext context) {
    final countToDisplayPending =
        isWishsBookedHidden ? nbWishsTotal : nbWishsPending;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: WishlistStatsCard(
              type: WishlistStatsCardType.pending,
              isSelected: statCardSelected == WishlistStatsCardType.pending,
              count: countToDisplayPending,
              onTap: () => onTapStatCard(WishlistStatsCardType.pending),
            ),
          ),
          const Gap(16),
          Expanded(
            child: WishlistStatsCard(
              type: WishlistStatsCardType.booked,
              isSelected: statCardSelected == WishlistStatsCardType.booked,
              count: nbWishsBooked,
              countIsHidden: isWishsBookedHidden,
              onTap: () => onTapStatCard(WishlistStatsCardType.booked),
            ),
          ),
        ],
      ),
    );
  }
}
