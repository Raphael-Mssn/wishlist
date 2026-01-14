import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/shared/theme/spacing.dart';

/// InheritedWidget pour exposer le padding du contenu aux écrans enfants
class NavBarPadding extends InheritedWidget {
  const NavBarPadding({
    super.key,
    required this.contentPadding,
    required super.child,
  });

  /// Padding à appliquer en bas des listes pour éviter la nav bar
  final double contentPadding;

  static double of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<NavBarPadding>();
    // Fallback sur la constante si pas dans un AppScaffold
    return widget?.contentPadding ?? AppSpacing.navBarContentPadding;
  }

  @override
  bool updateShouldNotify(NavBarPadding oldWidget) {
    return contentPadding != oldWidget.contentPadding;
  }
}

class AppScaffold extends ConsumerWidget {
  const AppScaffold({
    super.key,
    required this.bottomNavigationBar,
    required this.floatingActionButton,
    required this.body,
  });

  final Widget bottomNavigationBar;
  final Widget floatingActionButton;
  final Widget body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomSafeArea = MediaQuery.of(context).viewPadding.bottom;
    final gestureInsets = MediaQuery.of(context).systemGestureInsets.bottom;

    // Détecte Android avec 3 boutons de navigation
    // (gestureInsets == bottomSafeArea quand il y a des boutons système)
    final hasSystemNavButtons =
        gestureInsets == bottomSafeArea && bottomSafeArea > 0;
    final navBarBottomOffset = hasSystemNavButtons ? 8.0 : 0.0;

    final navBarBottomPosition = bottomSafeArea + navBarBottomOffset;
    final contentPadding = AppSpacing.navBarHeight + navBarBottomPosition;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: NavBarPadding(
        contentPadding: contentPadding,
        child: Stack(
          children: <Widget>[
            body,
            Positioned(
              bottom: navBarBottomPosition,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                width: MediaQuery.sizeOf(context).width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(child: bottomNavigationBar),
                    const Gap(32),
                    floatingActionButton,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
