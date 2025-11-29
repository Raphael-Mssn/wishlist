import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishlist/modules/auth/view/auth_screen.dart';
import 'package:wishlist/modules/auth/view/forgot_password_screen.dart';
import 'package:wishlist/modules/auth/view/pseudo_screen.dart';
import 'package:wishlist/modules/auth/view/reset_password_screen.dart';
import 'package:wishlist/modules/friends/view/screens/friend_details_screen.dart';
import 'package:wishlist/modules/settings/change_password/view/change_password_screen.dart';
import 'package:wishlist/modules/settings/change_pseudo/view/change_pseudo_screen.dart';
import 'package:wishlist/modules/settings/view/settings_screen.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_card.dart';
import 'package:wishlist/modules/wishlists/view/wishlist_screen.dart';
import 'package:wishlist/modules/wishs/view/screens/consult_wish_screen.dart';
import 'package:wishlist/modules/wishs/view/screens/edit_wish_screen.dart';
import 'package:wishlist/modules/wishs/view/wish_form_screen.dart';
import 'package:wishlist/shared/navigation/floating_nav_bar_navigator.dart';

part 'routes.g.dart';

// Route principale avec navigation bar
@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    // Pseudo (enfant de home)
    TypedGoRoute<PseudoRoute>(
      path: 'pseudo',
    ),
    // Settings et ses sous-routes
    TypedGoRoute<SettingsRoute>(
      path: 'settings',
      routes: [
        TypedGoRoute<ChangePasswordRoute>(
          path: 'change-password',
        ),
        TypedGoRoute<ChangePseudoRoute>(
          path: 'change-pseudo',
        ),
      ],
    ),
    // Wishlist et ses sous-routes
    TypedGoRoute<WishlistRoute>(
      path: 'wishlist/:wishlistId',
      routes: [
        TypedGoRoute<CreateWishRoute>(
          path: 'create-wish',
        ),
        TypedGoRoute<ConsultWishRoute>(
          path: 'wish/:wishId',
          routes: [
            TypedGoRoute<EditWishRoute>(
              path: 'edit',
            ),
          ],
        ),
      ],
    ),
    // Friend details (enfant de home)
    TypedGoRoute<FriendDetailsRoute>(
      path: 'friend/:friendId',
    ),
  ],
)
class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FloatingNavBarNavigator();
}

class PseudoRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PseudoScreen();
}

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

class CreateWishRoute extends GoRouteData {
  CreateWishRoute({
    required this.wishlistId,
  });

  final int wishlistId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return WishFormScreen(
      wishlistId: wishlistId,
    );
  }
}

class ConsultWishRoute extends GoRouteData {
  ConsultWishRoute(
    this.wishlistId,
    this.wishId, {
    required this.wishIds,
    this.isMyWishlist = false,
    this.cardType,
  });
  final int wishlistId;
  final int wishId;
  final List<int> wishIds;
  final bool isMyWishlist;
  final WishlistStatsCardType? cardType;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    // On calcule l'index du wishId dans la liste (0 si non trouvé)
    final initialIndex = wishIds.indexOf(wishId).clamp(0, wishIds.length - 1);

    return ConsultWishScreen(
      wishIds: wishIds,
      initialIndex: initialIndex,
      isMyWishlist: isMyWishlist,
      cardType: cardType,
    );
  }
}

class EditWishRoute extends GoRouteData {
  EditWishRoute({
    required this.wishlistId,
    required this.wishId,
  });

  final int wishlistId;
  final int wishId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EditWishScreen(wishId: wishId);
  }
}

class SettingsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}

class ChangePasswordRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ChangePasswordScreen();
}

class ChangePseudoRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ChangePseudoScreen();
}

class FriendDetailsRoute extends GoRouteData {
  FriendDetailsRoute(this.friendId);
  final String friendId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FriendDetailsScreen(friendId: friendId);
  }
}

// Route auth séparée (hors de la navigation principale)
@TypedGoRoute<AuthRoute>(
  path: '/auth',
  routes: [
    TypedGoRoute<ForgotPasswordRoute>(
      path: 'forgot-password',
    ),
    TypedGoRoute<ResetPasswordRoute>(
      path: 'reset-password',
    ),
  ],
)
class AuthRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) => const AuthScreen();
}

class ForgotPasswordRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ForgotPasswordScreen();
}

class ResetPasswordRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ResetPasswordScreen();
}
