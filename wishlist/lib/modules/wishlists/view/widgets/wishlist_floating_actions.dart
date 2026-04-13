import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/modules/wishlists/view/wishlist_screen_notifier.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/widgets/nav_bar_add_button.dart';

class WishlistFloatingActions extends ConsumerWidget {
  const WishlistFloatingActions({
    super.key,
    required this.wishlistId,
    required this.wishlistTheme,
    required this.onAdd,
    required this.onDelete,
    required this.onMove,
  });

  final int wishlistId;
  final ThemeData wishlistTheme;
  final VoidCallback onAdd;
  final VoidCallback onDelete;
  final VoidCallback onMove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenState = ref.watch(wishlistScreenNotifierProvider(wishlistId));
    final isSelection = screenState.isSelectionMode;
    final badgeCount = screenState.selectedWishIds.length;

    return Positioned(
      bottom: 24,
      right: 24,
      child: SizedBox(
        height: 240,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              bottom: isSelection ? 80 : 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isSelection ? 1 : 0,
                child: IgnorePointer(
                  ignoring: !isSelection,
                  child: _ActionButton(
                    icon: Icons.drive_file_move,
                    onPressed: onMove,
                    color: wishlistTheme.primaryColor,
                    colorDark: wishlistTheme.primaryColorDark,
                    showBadge: isSelection,
                    badgeCount: badgeCount,
                  ),
                ),
              ),
            ),
            _ActionButton(
              icon: isSelection ? Icons.delete : Icons.add,
              onPressed: isSelection ? onDelete : onAdd,
              color: isSelection ? Colors.red : wishlistTheme.primaryColor,
              colorDark: isSelection
                  ? AppColors.darken(Colors.red)
                  : wishlistTheme.primaryColorDark,
              showBadge: isSelection,
              badgeCount: badgeCount,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.onPressed,
    required this.color,
    required this.colorDark,
    this.showBadge = false,
    this.badgeCount = 0,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final Color colorDark;
  final bool showBadge;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            primaryColor: color,
            primaryColorDark: colorDark,
          ),
          child: NavBarAddButton(icon: icon, onPressed: onPressed),
        ),
        if (showBadge) _SelectionBadge(count: badgeCount),
      ],
    );
  }
}

class _SelectionBadge extends StatelessWidget {
  const _SelectionBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -4,
      right: -4,
      child: Container(
        constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.darkGrey,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.background, width: 2),
        ),
        child: Center(
          child: Text(
            '$count',
            style: AppTextStyles.smaller.copyWith(
              color: AppColors.background,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
