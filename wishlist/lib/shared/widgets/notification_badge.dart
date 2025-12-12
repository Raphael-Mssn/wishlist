import 'package:flutter/material.dart';
import 'package:wishlist/shared/theme/colors.dart';

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({
    super.key,
    required this.show,
    this.size = 10,
    this.color = AppColors.primary,
  });

  final bool show;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: show ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
