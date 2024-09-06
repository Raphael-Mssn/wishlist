import 'package:flutter/material.dart';
import 'package:wishlist/shared/theme/colors.dart';

class AppRefreshIndicator extends StatelessWidget {
  const AppRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 0,
      color: AppColors.darkGrey,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
