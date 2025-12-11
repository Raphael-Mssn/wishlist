import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/friendships_realtime_provider.dart';
import 'package:wishlist/shared/navigation/floating_nav_bar_navigator.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/widgets/notification_badge.dart';

class FloatingNavBar extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        onTabChanged(FloatingNavBarTab.values[tabController.index]);
      }
    });

    final friendshipsAsync = ref.watch(friendshipsRealtimeProvider);
    final hasPendingRequests = friendshipsAsync.maybeWhen(
      data: (friendsData) => friendsData.requestedFriends.isNotEmpty,
      orElse: () => false,
    );

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
        tabs: [
          const _TabIcon(icon: Icons.home),
          _TabIcon(icon: Icons.group, showBadge: hasPendingRequests),
          const _TabIcon(icon: Icons.bookmark),
        ],
      ),
    );
  }
}

class _TabIcon extends StatelessWidget {
  const _TabIcon({
    required this.icon,
    this.showBadge = false,
  });

  final IconData icon;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            icon,
            size: 36,
          ),
          Positioned(
            top: -4,
            right: -4,
            child: NotificationBadge(show: showBadge),
          ),
        ],
      ),
    );
  }
}
