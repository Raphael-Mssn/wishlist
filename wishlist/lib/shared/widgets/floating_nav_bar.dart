import 'package:flutter/material.dart';
import 'package:wishlist/shared/navigation/floating_nav_bar_navigator.dart';
import 'package:wishlist/shared/theme/colors.dart';

class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({super.key, required this.onTabChanged});

  final void Function(FloatingNavBarTab) onTabChanged;

  @override
  Widget build(BuildContext context) {
    void onTabTapped(TabController tabController) {
      if (tabController.indexIsChanging) {
        return;
      }
      return onTabChanged(FloatingNavBarTab.values[tabController.index]);
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: DefaultTabController(
        length: 3,
        child: Builder(
          builder: (context) {
            final controller = DefaultTabController.of(context);
            controller.addListener(() {
              onTabTapped(controller);
            });
            return const TabBar(
              tabs: [
                _TabIcon(icon: Icons.home),
                _TabIcon(icon: Icons.person),
                _TabIcon(icon: Icons.settings),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TabIcon extends StatelessWidget {
  const _TabIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Icon(
        icon,
        size: 32,
      ),
    );
  }
}
