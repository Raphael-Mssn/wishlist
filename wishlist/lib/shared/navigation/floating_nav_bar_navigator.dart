import 'package:flutter/material.dart';
import 'package:wishlist/modules/friends/view/friends_screen.dart';
import 'package:wishlist/modules/home/view/home_screen.dart';
import 'package:wishlist/modules/settings/view/settings_screen.dart';
import 'package:wishlist/shared/theme/widgets/app_scaffold.dart';
import 'package:wishlist/shared/widgets/create_dialog.dart';
import 'package:wishlist/shared/widgets/floating_nav_bar.dart';
import 'package:wishlist/shared/widgets/nav_bar_add_button.dart';

enum FloatingNavBarTab { home, friends, settings }

class FloatingNavBarNavigator extends StatefulWidget {
  const FloatingNavBarNavigator({
    super.key,
    this.currentTab = FloatingNavBarTab.home,
  });

  final FloatingNavBarTab currentTab;

  @override
  State<FloatingNavBarNavigator> createState() =>
      _FloatingNavBarNavigatorState();
}

class _FloatingNavBarNavigatorState extends State<FloatingNavBarNavigator> {
  late FloatingNavBarTab _currentTab = widget.currentTab;

  Widget _buildBody() {
    switch (_currentTab) {
      case FloatingNavBarTab.home:
        return const HomeScreen();
      case FloatingNavBarTab.friends:
        return const FriendsScreen();
      case FloatingNavBarTab.settings:
        return const SettingsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      floatingActionButton: NavBarAddButton(
        onPressed: () {
          showCreateDialog(context);
        },
      ),
      bottomNavigationBar: FloatingNavBar(
        onTabChanged: (tab) {
          print('Tab changed to $tab');
          setState(() {
            _currentTab = tab;
          });
        },
      ),
      body: _buildBody(),
    );
  }
}
