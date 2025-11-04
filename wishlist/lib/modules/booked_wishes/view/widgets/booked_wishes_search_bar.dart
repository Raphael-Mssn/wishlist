import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/booked_wishes/view/widgets/booked_wish_sort_bottom_sheet.dart';
import 'package:wishlist/shared/models/booked_wish_sort_type.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

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

  static const double _verticalPadding = 16;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        _verticalPadding,
        12,
        _verticalPadding,
        12,
      ),
      decoration: const BoxDecoration(
        color: AppColors.gainsboro,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
          bottom: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SearchField(
              searchController: searchController,
              searchFocusNode: searchFocusNode,
              searchQuery: searchQuery,
              onClearFocus: onClearFocus,
            ),
          ),
          const Gap(12),
          _SortButton(
            sort: sort,
            onSortChanged: onSortChanged,
          ),
          const Gap(8),
          _OrderButton(
            sort: sort,
            onSortChanged: onSortChanged,
          ),
        ],
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton({
    required this.sort,
    required this.onSortChanged,
  });

  final BookedWishSort sort;
  final Function(BookedWishSort) onSortChanged;

  static const double _searchBarBorderRadius = 6;
  static const double _sortButtonSize = 40;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        width: _sortButtonSize,
        height: _sortButtonSize,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(_searchBarBorderRadius),
        ),
        child: InkWell(
          onTap: () {
            showBookedWishSortBottomSheet(
              context,
              currentSort: sort,
              onSortChanged: onSortChanged,
            );
          },
          borderRadius: BorderRadius.circular(_searchBarBorderRadius),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.sort,
                size: 24,
                color: AppColors.darkGrey,
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: Icon(
                  sort.type.icon,
                  size: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderButton extends StatelessWidget {
  const _OrderButton({
    required this.sort,
    required this.onSortChanged,
  });

  final BookedWishSort sort;
  final Function(BookedWishSort) onSortChanged;

  static const double _searchBarBorderRadius = 6;
  static const double _sortButtonSize = 40;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        width: _sortButtonSize,
        height: _sortButtonSize,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(_searchBarBorderRadius),
        ),
        child: InkWell(
          onTap: () {
            final newSort = sort.toggleOrder();
            onSortChanged(newSort);
          },
          borderRadius: BorderRadius.circular(_searchBarBorderRadius),
          child: Icon(
            sort.icon,
            size: 20,
            color: AppColors.darkGrey,
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.searchController,
    required this.searchFocusNode,
    required this.searchQuery,
    required this.onClearFocus,
  });

  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final String searchQuery;
  final VoidCallback onClearFocus;

  static const double _searchBarBorderRadius = 6;
  static const double _searchFontSize = 16;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(_searchBarBorderRadius),
      ),
      child: TextField(
        controller: searchController,
        focusNode: searchFocusNode,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: l10n.bookedWishesSearchHint,
          hintStyle: AppTextStyles.small.copyWith(
            color: AppColors.makara,
            fontSize: _searchFontSize,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.makara,
            size: 20,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: AppColors.makara,
                    size: 18,
                  ),
                  onPressed: () {
                    searchController.clear();
                    onClearFocus();
                  },
                )
              : null,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_searchBarBorderRadius),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          enabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          isDense: true,
        ),
        style: AppTextStyles.small.copyWith(
          color: AppColors.darkGrey,
          fontSize: _searchFontSize,
        ),
        cursorColor: Theme.of(context).primaryColor,
        onTapOutside: (event) => onClearFocus(),
      ),
    );
  }
}
