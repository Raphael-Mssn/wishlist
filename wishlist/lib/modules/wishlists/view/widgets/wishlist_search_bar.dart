import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wish_sort_bottom_sheet.dart';
import 'package:wishlist/shared/models/wish/wish_sort_type.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/widgets/search_bar/app_search_bar.dart';

class WishlistSearchBar extends StatelessWidget {
  const WishlistSearchBar({
    super.key,
    required this.searchController,
    required this.searchFocusNode,
    required this.searchQuery,
    required this.wishSort,
    required this.onSortChanged,
    required this.onClearFocus,
  });

  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final String searchQuery;
  final WishSort wishSort;
  final Function(WishSort) onSortChanged;
  final VoidCallback onClearFocus;

  static const double _verticalPadding = 16;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        _verticalPadding,
        12,
        _verticalPadding,
        0,
      ),
      decoration: const BoxDecoration(
        color: AppColors.gainsboro,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SearchField(
              searchController: searchController,
              searchFocusNode: searchFocusNode,
              searchQuery: searchQuery,
              hintText: context.l10n.wishlistSearchHint,
              onClearFocus: onClearFocus,
            ),
          ),
          const Gap(12),
          SearchBarButton(
            icon: Icons.sort,
            smallIcon: wishSort.type.icon,
            onTap: () {
              showWishSortBottomSheet(
                context,
                currentSort: wishSort,
                onSortChanged: onSortChanged,
              );
            },
          ),
          if (wishSort.type != WishSortType.favorite) ...[
            const Gap(8),
            SearchBarButton(
              icon: wishSort.icon,
              onTap: () {
                final newSort = wishSort.toggleOrder();
                onSortChanged(newSort);
              },
            ),
          ],
        ],
      ),
    );
  }
}
