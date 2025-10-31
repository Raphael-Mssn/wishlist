import 'package:flutter/material.dart';
import 'package:wishlist/shared/theme/colors.dart';

/// Widget qui affiche un indicateur de présence en ligne
/// (petit cercle vert avec bordure blanche)
class OnlineIndicator extends StatelessWidget {
  const OnlineIndicator({
    super.key,
    this.size = 12,
    this.borderWidth = 2,
  });

  final double size;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.green,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.background,
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }
}
