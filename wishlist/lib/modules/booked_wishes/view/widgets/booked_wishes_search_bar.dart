import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/booked_wishes/view/widgets/booked_wish_sort_bottom_sheet.dart';
import 'package:wishlist/shared/models/booked_wish_sort_type.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/widgets/search_bar/app_search_bar.dart';

class BookedWishesSearchBar extends StatelessWidget {
  const BookedWishesSearchBar({
    super.key,
    required this.searchController,
    required this.searchFocusNode,
    required this.searchQuery,
    required this.sort,
    required this.onSortChanged,
    required this.onClearFocus,
  });

  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final String searchQuery;
  final BookedWishSort sort;
  final Function(BookedWishSort) onSortChanged;
  final VoidCallback onClearFocus;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: AppColors.gainsboro,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SearchField(
              searchController: searchController,
              searchFocusNode: searchFocusNode,
              searchQuery: searchQuery,
              hintText: l10n.bookedWishesSearchHint,
              onClearFocus: onClearFocus,
            ),
          ),
          const Gap(12),
          SearchBarButton(
            icon: Icons.sort,
            smallIcon: sort.type.icon,
            onTap: () {
              showBookedWishSortBottomSheet(
                context,
                currentSort: sort,
                onSortChanged: onSortChanged,
              );
            },
          ),
          const Gap(8),
          SearchBarButton(
            icon: sort.icon,
            onTap: () {
              final newSort = sort.toggleOrder();
              onSortChanged(newSort);
            },
          ),
        ],
      ),
    );
  }
}
