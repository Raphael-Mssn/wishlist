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
    late double iconSize;
    late double containerSize;
    late double innerContainerSize;
    late double paddingSize;

    switch (icon) {
      case Icons.add:
        iconSize = size == NavBarButtonSize.large ? 46.0 : 36.0;
      case Icons.person_add_alt_1:
        iconSize = size == NavBarButtonSize.large ? 36.0 : 26.0;
      default:
        iconSize = size == NavBarButtonSize.large ? 46.0 : 36.0;
    }

    containerSize = size == NavBarButtonSize.large ? 70.0 : 40.0;
    innerContainerSize = size == NavBarButtonSize.large ? 50.0 : 40.0;
    paddingSize = size == NavBarButtonSize.large ? 10.0 : 5.0;

    return _Dimensions(
      iconSize: iconSize,
      containerSize: containerSize,
      innerContainerSize: innerContainerSize,
      paddingSize: paddingSize,
    );
  }
}

enum NavBarButtonSize { small, large }

class _Dimensions {
  _Dimensions({
    required this.iconSize,
    required this.containerSize,
    required this.innerContainerSize,
    required this.paddingSize,
  });

  final double iconSize;
  final double containerSize;
  final double innerContainerSize;
  final double paddingSize;
}
