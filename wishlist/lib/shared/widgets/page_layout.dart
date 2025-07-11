import 'package:flutter/material.dart';
import 'package:wishlist/shared/theme/widgets/app_app_bar.dart';
import 'package:wishlist/shared/theme/widgets/app_refresh_indicator.dart';

class PageLayout extends StatelessWidget {
  const PageLayout({
    super.key,
    required this.title,
    required this.child,
    this.onRefresh,
    this.padding = const EdgeInsets.all(20),
  });

  final String title;
  final Widget child;
  final Future<void> Function()? onRefresh;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final onRefresh = this.onRefresh;

    return Scaffold(
      appBar: AppAppBar(title: title),
      body: Padding(
        padding: padding,
        child: onRefresh != null
            ? AppRefreshIndicator(
                onRefresh: onRefresh,
                child: child,
              )
            : child,
      ),
    );
  }
}
