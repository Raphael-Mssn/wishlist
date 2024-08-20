import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/modules/friends/view/friends_screen.dart';
import 'package:wishlist/modules/home/view/home_screen.dart';
import 'package:wishlist/modules/settings/view/settings_screen.dart';
import 'package:wishlist/shared/theme/widgets/app_scaffold.dart';
import 'package:wishlist/shared/widgets/dialogs/create_dialog.dart';
import 'package:wishlist/shared/widgets/floating_nav_bar.dart';
import 'package:wishlist/shared/widgets/nav_bar_add_button.dart';

enum FloatingNavBarTab { home, friends, settings }

class FloatingNavBarNavigator extends ConsumerStatefulWidget {
  const FloatingNavBarNavigator({
    super.key,
    this.currentTab = FloatingNavBarTab.home,
  });

  final FloatingNavBarTab currentTab;

  @override
  ConsumerState<FloatingNavBarNavigator> createState() =>
      _FloatingNavBarNavigatorState();
}

class _FloatingNavBarNavigatorState
    extends ConsumerState<FloatingNavBarNavigator>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late TabController _tabController;
  IconData floatingActionButtonIcon = Icons.add;
  late VoidCallback onFloatingActionButtonPressed =
      () => showCreateDialog(context, ref);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: FloatingNavBarTab.values.indexOf(widget.currentTab),
    );
    _tabController = TabController(
      length: FloatingNavBarTab.values.length,
      vsync: this,
      initialIndex: FloatingNavBarTab.values.indexOf(widget.currentTab),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void updateFloatingAction() {
    setState(() {
      floatingActionButtonIcon = const [
        Icons.add,
        Icons.person_add_alt_1,
        Icons.add,
      ][_tabController.index];

      onFloatingActionButtonPressed = [
        () => showCreateDialog(context, ref),
        () {},
        () => showCreateDialog(context, ref),
      ][_tabController.index];
    });
  }

  void _onPageChanged(int index) {
    _tabController.animateTo(index);
    updateFloatingAction();
  }

  void _onTabChanged(FloatingNavBarTab tab) {
    final pageIndex = FloatingNavBarTab.values.indexOf(tab);
    final pageControllerPage = _pageController.page;
    // pageControllerPage should never be null
    if (pageControllerPage == null) {
      return;
    }

    if ((pageControllerPage - pageIndex).abs() >= 2) {
      // si différence de + de 2 pages, on ne fait pas l'animation
      _pageController.jumpToPage(pageIndex);
    } else {
      _pageController.animateToPage(
        pageIndex,
        duration: kThemeChangeDuration,
        curve: Curves.easeInOut,
      );
    }
    updateFloatingAction();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      floatingActionButton: NavBarAddButton(
        icon: floatingActionButtonIcon,
        onPressed: onFloatingActionButtonPressed,
      ),
      bottomNavigationBar: FloatingNavBar(
        onTabChanged: _onTabChanged,
        currentTab: FloatingNavBarTab.values[_tabController.index],
        tabController: _tabController,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: const [
          HomeScreen(),
          FriendsScreen(),
          SettingsScreen(),
        ],
      ),
    );
  }
}
