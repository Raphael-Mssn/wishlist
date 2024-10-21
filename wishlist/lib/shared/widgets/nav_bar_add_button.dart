import 'package:flutter/material.dart';
import 'package:wishlist/shared/theme/colors.dart';

class NavBarAddButton extends StatelessWidget {
  const NavBarAddButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final iconSize = switch (icon) {
      Icons.add => 46.0,
      Icons.person_add_alt_1 => 36.0,
      _ => 46.0,
    };

    final theme = Theme.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Ombre en dessous de tout
        Container(
          width: 70,
          height: 70,
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
            borderRadius: BorderRadius.circular(50),
            child: Ink(
              decoration: BoxDecoration(
                color: theme.primaryColor,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: Ink(
                decoration: BoxDecoration(
                  color: theme.primaryColorDark,
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  width: 50,
                  height: 50,
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
                      size: iconSize,
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
}
