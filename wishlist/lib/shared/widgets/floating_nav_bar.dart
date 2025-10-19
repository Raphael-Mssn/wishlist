import 'package:flutter/material.dart';
import 'package:wishlist/shared/navigation/floating_nav_bar_navigator.dart';
import 'package:wishlist/shared/theme/colors.dart';

class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({
    super.key,
    required this.onTabChanged,
    required this.currentTab,
    required this.tabController,
  });

  final void Function(FloatingNavBarTab) onTabChanged;
  final FloatingNavBarTab currentTab;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        onTabChanged(FloatingNavBarTab.values[tabController.index]);
      }
    });

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
      child: TabBar(
        controller: tabController,
        tabs: const [
          _TabIcon(icon: Icons.home),
          _TabIcon(icon: Icons.group),
          _TabIcon(icon: Icons.bookmark),
        ],
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
        size: 36,
      ),
    );
  }
}
