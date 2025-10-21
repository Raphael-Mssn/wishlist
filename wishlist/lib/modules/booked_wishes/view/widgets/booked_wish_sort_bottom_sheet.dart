import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/models/booked_wish_sort_type.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

void showBookedWishSortBottomSheet(
  BuildContext context, {
  required BookedWishSort currentSort,
  required Function(BookedWishSort) onSortChanged,
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
    builder: (context) {
      return BookedWishSortBottomSheet(
        currentSort: currentSort,
        onSortChanged: onSortChanged,
      );
    },
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

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.sortWishs,
            style: AppTextStyles.title.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            ),
          ),
          const Gap(16),
          ...BookedWishSortType.values.map((sortType) {
            final isSelected = currentSort.type == sortType;
            return _SortOption(
              label: sortType.getLabel(l10n),
              icon: sortType.icon,
              isSelected: isSelected,
              onTap: () {
                onSortChanged(
                  BookedWishSort(
                    type: sortType,
                    order: currentSort.order,
                  ),
                );
                Navigator.of(context).pop();
              },
            );
          }),
          const Gap(8),
        ],
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  const _SortOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : AppColors.makara,
                size: 24,
              ),
              const Gap(12),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.medium.copyWith(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : AppColors.darkGrey,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
