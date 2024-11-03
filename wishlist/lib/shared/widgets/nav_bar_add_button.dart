import 'package:flutter/material.dart';
import 'package:wishlist/shared/theme/colors.dart';

class NavBarAddButton extends StatelessWidget {
  const NavBarAddButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.size = NavBarButtonSize.large,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final NavBarButtonSize size;

  @override
  Widget build(BuildContext context) {
    final dimensions = _getDimensions(size, icon);

    final theme = Theme.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Ombre en dessous de tout
        Container(
          width: dimensions.containerSize,
          height: dimensions.containerSize,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.darkGrey.withOpacity(0.15),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(dimensions.containerSize / 2),
            child: Ink(
              decoration: BoxDecoration(
                color: theme.primaryColor,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(dimensions.paddingSize),
              child: Ink(
                decoration: BoxDecoration(
                  color: theme.primaryColorDark,
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  width: dimensions.innerContainerSize,
                  height: dimensions.innerContainerSize,
                  child: AnimatedSwitcher(
                    duration: kThemeAnimationDuration,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(scale: animation, child: child),
                      );
                    },
                    child: Icon(
                      icon,
                      key: ValueKey<IconData>(icon),
                      size: dimensions.iconSize,
                      color: AppColors.background,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _Dimensions _getDimensions(NavBarButtonSize size, IconData icon) {
    switch (size) {
      case NavBarButtonSize.large:
        return switch (icon) {
          Icons.add => _Dimensions(46, 70, 50, 10),
          Icons.person_add_alt_1 => _Dimensions(36, 70, 50, 10),
          _ => _Dimensions(46, 70, 50, 10),
        };
      case NavBarButtonSize.small:
        return switch (icon) {
          Icons.add => _Dimensions(36, 40, 40, 5),
          Icons.person_add_alt_1 => _Dimensions(26, 40, 40, 5),
          _ => _Dimensions(36, 40, 40, 5),
        };
    }
  }
}

enum NavBarButtonSize { small, large }

class _Dimensions {
  _Dimensions(
    this.iconSize,
    this.containerSize,
    this.innerContainerSize,
    this.paddingSize,
  );

  final double iconSize;
  final double containerSize;
  final double innerContainerSize;
  final double paddingSize;
}
