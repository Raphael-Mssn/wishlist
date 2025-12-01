import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/models/booked_wish_sort_type.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/widgets/app_bottom_sheet.dart';
import 'package:wishlist/shared/widgets/app_list_tile.dart';

Future<void> showBookedWishSortBottomSheet(
  BuildContext context, {
  required BookedWishSort currentSort,
  required Function(BookedWishSort) onSortChanged,
}) async {
  await showAppBottomSheet(
    context,
    expandToFillHeight: false,
    body: BookedWishSortBottomSheet(
      currentSort: currentSort,
      onSortChanged: onSortChanged,
    ),
  );
}

class BookedWishSortBottomSheet extends StatelessWidget {
  const BookedWishSortBottomSheet({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
  });

  final BookedWishSort currentSort;
  final Function(BookedWishSort) onSortChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            l10n.sortWishs,
            style: AppTextStyles.medium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...BookedWishSortType.values.map(
          (sortType) => AppListTile(
            icon: sortType.icon,
            title: sortType.getLabel(l10n),
            isSelected: currentSort.type == sortType,
            showCheckmark: true,
            onTap: () {
              final newSort = BookedWishSort(
                type: sortType,
                order: currentSort.order,
              );
              onSortChanged(newSort);
              Navigator.of(context).pop();
            },
          ),
        ),
        const Gap(16),
      ],
    );
  }
}
