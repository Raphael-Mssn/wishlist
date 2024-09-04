import 'package:flutter/material.dart';
import 'package:wishlist/main.dart';
import 'package:wishlist/modules/auth/view/auth_screen.dart';
import 'package:wishlist/modules/auth/view/pseudo_screen.dart';
import 'package:wishlist/modules/friends/view/screens/friend_details_screen.dart';
import 'package:wishlist/modules/settings/change_password/view/change_password_screen.dart';
import 'package:wishlist/modules/wishlists/view/wishlist_screen.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/navigation/floating_nav_bar_navigator.dart';
import 'package:wishlist/shared/navigation/routes.dart';

MaterialPageRoute<void> onGenerateRoute(RouteSettings settings) =>
    MaterialPageRoute<void>(
      settings: settings,
      builder: (context) {
        // Protect the app from showing any screen if the user is not
        // authenticated
        final activeSession = supabase.auth.currentSession;
        if (activeSession == null) {
          return const AuthScreen();
        }

        // Protect the app from showing any screen if the user has not set a
        // pseudo = has a profile
        final hasPseudo =
            activeSession.user.userMetadata?.containsKey('pseudo');

        if (hasPseudo == null || hasPseudo == false) {
          return const PseudoScreen();
        }

        final routeName = settings.name;

        if (routeName == AppRoutes.pseudo.name) {
          return const PseudoScreen();
        }

        if (routeName == AppRoutes.home.name) {
          return const FloatingNavBarNavigator();
        }

        if (routeName == AppRoutes.wishlist.name) {
          final wishlist = settings.arguments;
          if (wishlist != null) {
            return WishlistScreen(wishlist: wishlist as Wishlist);
          }
        }

        if (routeName == AppRoutes.settings.name) {
          return const FloatingNavBarNavigator(
            currentTab: FloatingNavBarTab.settings,
          );
        }

        if (routeName == AppRoutes.changePassword.name) {
          return const ChangePasswordScreen();
        }

        if (routeName == AppRoutes.auth.name) {
          return const AuthScreen();
        }

        if (routeName == AppRoutes.friendDetails.name) {
          final friendId = settings.arguments;
          if (friendId != null) {
            return FriendDetailsScreen(
              friendId: friendId as String,
            );
          }
        }

        return const SizedBox.shrink();
      },
    );
