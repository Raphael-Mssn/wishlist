import 'package:flutter/material.dart';
import 'package:wishlist/shared/theme/colors.dart';

class NavBarAddButton extends StatelessWidget {
  const NavBarAddButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(50),
        child: Ink(
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(10),
          child: Ink(
            decoration: const BoxDecoration(
              color: AppColors.darkOrange,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(2),
            child: const Icon(
              Icons.add,
              size: 46,
              color: AppColors.background,
            ),
          ),
        ),
      ),
    );
  }
}
