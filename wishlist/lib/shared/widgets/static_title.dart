import 'package:flutter/material.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

class StaticTitle extends StatelessWidget {
  const StaticTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.medium.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
