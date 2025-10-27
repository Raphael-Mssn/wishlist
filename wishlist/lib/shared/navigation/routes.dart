import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishlist/modules/auth/view/auth_screen.dart';
import 'package:wishlist/modules/auth/view/forgot_password_screen.dart';
import 'package:wishlist/modules/auth/view/pseudo_screen.dart';
import 'package:wishlist/modules/auth/view/reset_password_screen.dart';
import 'package:wishlist/modules/friends/view/screens/friend_details_screen.dart';
import 'package:wishlist/modules/settings/change_password/view/change_password_screen.dart';
import 'package:wishlist/modules/wishlists/view/wishlist_screen.dart';
import 'package:wishlist/shared/navigation/floating_nav_bar_navigator.dart';

part 'routes.g.dart';

@TypedGoRoute<HomeRoute>(
  path: '/',
)
class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FloatingNavBarNavigator();
}

@TypedGoRoute<PseudoRoute>(
  path: '/pseudo',
)
class PseudoRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PseudoScreen();
}

@TypedGoRoute<WishlistRoute>(
  path: '/wishlist/:wishlistId',
)
class WishlistRoute extends GoRouteData {
  WishlistRoute({
    required this.wishlistId,
  });

  final int wishlistId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return WishlistScreen(
      wishlistId: wishlistId,
    );
  }
}

@TypedGoRoute<SettingsRoute>(
  path: '/settings',
)
class SettingsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FloatingNavBarNavigator(currentTab: FloatingNavBarTab.settings);
}

@TypedGoRoute<ChangePasswordRoute>(
  path: '/change-password',
)
class ChangePasswordRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ChangePasswordScreen();
}

@TypedGoRoute<AuthRoute>(
  path: '/auth',
)
class AuthRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) => const AuthScreen();
}

@TypedGoRoute<FriendDetailsRoute>(
  path: '/friend/:friendId',
)
class FriendDetailsRoute extends GoRouteData {
  FriendDetailsRoute(this.friendId);
  final String friendId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FriendDetailsScreen(friendId: friendId);
  }
}

@TypedGoRoute<ForgotPasswordRoute>(
  path: '/forgot-password',
)
class ForgotPasswordRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ForgotPasswordScreen();
}

@TypedGoRoute<ResetPasswordRoute>(
  path: '/reset-password',
)
class ResetPasswordRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ResetPasswordScreen();
}
