import 'package:flutter/material.dart';
import 'package:wishlist/shared/theme/colors.dart';

class Pill extends StatelessWidget {
  const Pill({
    super.key,
    required this.text,
    required this.backgroundColor,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  final String text;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGrey.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: textStyle?.copyWith(
              color: AppColors.background,
              fontWeight: FontWeight.bold,
              height: 1,
            ) ??
            const TextStyle(
              color: AppColors.background,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
      ),
    );
  }
}
