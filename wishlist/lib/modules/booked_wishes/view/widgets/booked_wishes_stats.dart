import 'package:flutter/material.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/models/booked_wish_with_details/booked_wish_with_details.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

class BookedWishesStats extends StatelessWidget {
  const BookedWishesStats({
    super.key,
    required this.bookedWishes,
  });

  final List<BookedWishWithDetails> bookedWishes;

  int get _totalCount => bookedWishes.length;

  double? get _totalBudget {
    double total = 0;
    var hasPrice = false;

    for (final bookedWish in bookedWishes) {
      final price = bookedWish.wish.price;
      if (price != null && price > 0) {
        total += price;
        hasPrice = true;
      }
    }

    return hasPrice ? total : null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final totalBudget = _totalBudget;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Icon(
            Icons.card_giftcard,
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.small.copyWith(
                  color: AppColors.darkGrey,
                ),
                children: [
                  TextSpan(
                    text: l10n.bookedWishCount(_totalCount),
                    style: const TextStyle(
                      color: AppColors.darkGrey,
                    ),
                  ),
                  if (totalBudget != null) ...[
                    const TextSpan(text: ' • '),
                    TextSpan(
                      text: '${totalBudget.toStringAsFixed(0)}€',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
