import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/models/wish/wish_sort_type.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/widgets/app_bottom_sheet.dart';
import 'package:wishlist/shared/widgets/app_list_tile.dart';

class _WishSortBottomSheet extends StatelessWidget {
  const _WishSortBottomSheet({
    required this.currentSort,
    required this.onSortChanged,
  });

  final WishSort currentSort;
  final void Function(WishSort) onSortChanged;

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
        ...WishSortType.values.map(
          (sortType) => AppListTile(
            icon: sortType.icon,
            title: sortType.getLabel(l10n),
            isSelected: currentSort.type == sortType,
            showCheckmark: true,
            onTap: () {
              final newSort = WishSort(
                type: sortType,
                order: currentSort.order, // Conserver l'ordre actuel
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

Future<void> showWishSortBottomSheet(
  BuildContext context, {
  required WishSort currentSort,
  required void Function(WishSort) onSortChanged,
}) async {
  await showAppBottomSheet(
    context,
    expandToFillHeight: false,
    body: _WishSortBottomSheet(
      currentSort: currentSort,
      onSortChanged: onSortChanged,
    ),
  );
}
