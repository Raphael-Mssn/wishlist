import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishlist/modules/wishs/view/widgets/consult_box_shadow.dart';
import 'package:wishlist/shared/theme/colors.dart';

class ConsultWishBackButton extends StatelessWidget {
  const ConsultWishBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              consultBoxShadow,
            ],
          ),
          child: IconButton.filled(
            padding: const EdgeInsets.all(6),
            onPressed: () => context.pop(),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.background,
              foregroundColor: AppColors.darkGrey,
            ),
            icon: const Icon(Icons.keyboard_arrow_left, size: 32),
          ),
        ),
      ),
    );
  }
}
