import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

/// Barre de recherche générique avec boutons de tri et d'ordre
class AppSearchBar<T> extends StatelessWidget {
  const AppSearchBar({
    super.key,
    required this.searchController,
    required this.searchFocusNode,
    required this.searchQuery,
    required this.hintText,
    required this.sort,
    required this.onSortChanged,
    required this.onClearFocus,
    required this.onSortButtonTap,
    required this.sortIcon,
    this.showOrderButton = true,
  });

  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final String searchQuery;
  final String hintText;
  final T sort;
  final Function(T) onSortChanged;
  final VoidCallback onClearFocus;
  final VoidCallback onSortButtonTap;
  final IconData sortIcon;
  final bool showOrderButton;

  static const double _horizontalPadding = 16;
  static const double _verticalPadding = 12;
  static const BorderRadius _defaultBorderRadius = BorderRadius.vertical(
    top: Radius.circular(16),
    bottom: Radius.circular(16),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
      ),
      decoration: const BoxDecoration(
        color: AppColors.gainsboro,
        borderRadius: _defaultBorderRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: SearchField(
              searchController: searchController,
              searchFocusNode: searchFocusNode,
              searchQuery: searchQuery,
              hintText: hintText,
              onClearFocus: onClearFocus,
            ),
          ),
          const Gap(12),
          SearchBarButton(
            icon: Icons.sort,
            smallIcon: sortIcon,
            onTap: onSortButtonTap,
          ),
          if (showOrderButton) ...[
            const Gap(8),
            SearchBarButton(
              icon: _getOrderIcon(),
              onTap: () {
                final newSort = _toggleOrder();
                onSortChanged(newSort);
              },
            ),
          ],
        ],
      ),
    );
  }

  IconData _getOrderIcon() {
    // Cette méthode sera surchargée par les implémentations spécifiques
    return Icons.sort;
  }

  T _toggleOrder() {
    // Cette méthode sera surchargée par les implémentations spécifiques
    return sort;
  }
}

/// Champ de recherche
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.searchController,
    required this.searchFocusNode,
    required this.searchQuery,
    required this.hintText,
    required this.onClearFocus,
  });

  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final String searchQuery;
  final String hintText;
  final VoidCallback onClearFocus;

  static const double _searchBarBorderRadius = 12;
  static const double _searchFontSize = 16;
  static const BoxConstraints _prefixIconConstraints = BoxConstraints(
    minWidth: 40,
    minHeight: 40,
  );

  @override
  Widget build(BuildContext context) {
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
          hintText: hintText,
          hintStyle: AppTextStyles.small.copyWith(
            color: AppColors.makara,
            fontSize: _searchFontSize,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.makara,
            size: 20,
          ),
          prefixIconConstraints: _prefixIconConstraints,
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

/// Bouton de tri/ordre réutilisable
class SearchBarButton extends StatelessWidget {
  const SearchBarButton({
    super.key,
    required this.icon,
    this.smallIcon,
    required this.onTap,
  });

  final IconData icon;
  final IconData? smallIcon;
  final VoidCallback onTap;

  static const double _searchBarBorderRadius = 12;
  static const double _buttonSize = 40;
  static const double _smallIcon = 4;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        width: _buttonSize,
        height: _buttonSize,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(_searchBarBorderRadius),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_searchBarBorderRadius),
          child: smallIcon != null
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 24,
                      color: AppColors.darkGrey,
                    ),
                    Positioned(
                      bottom: _smallIcon,
                      right: _smallIcon,
                      child: Icon(
                        smallIcon,
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                )
              : Icon(
                  icon,
                  size: 20,
                  color: AppColors.darkGrey,
                ),
        ),
      ),
    );
  }
}
