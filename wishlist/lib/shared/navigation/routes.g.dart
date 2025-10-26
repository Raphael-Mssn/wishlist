// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeRoute,
      $pseudoRoute,
      $wishlistRoute,
      $settingsRoute,
      $changePasswordRoute,
      $changePseudoRoute,
      $authRoute,
      $friendDetailsRoute,
    ];

RouteBase get $homeRoute => GoRouteData.$route(
      path: '/',
      factory: $HomeRouteExtension._fromState,
    );

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => HomeRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $pseudoRoute => GoRouteData.$route(
      path: '/pseudo',
      factory: $PseudoRouteExtension._fromState,
    );

extension $PseudoRouteExtension on PseudoRoute {
  static PseudoRoute _fromState(GoRouterState state) => PseudoRoute();

  String get location => GoRouteData.$location(
        '/pseudo',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $wishlistRoute => GoRouteData.$route(
      path: '/wishlist/:wishlistId',
      factory: $WishlistRouteExtension._fromState,
    );

extension $WishlistRouteExtension on WishlistRoute {
  static WishlistRoute _fromState(GoRouterState state) => WishlistRoute(
        wishlistId: int.parse(state.pathParameters['wishlistId']!),
      );

  String get location => GoRouteData.$location(
        '/wishlist/${Uri.encodeComponent(wishlistId.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $settingsRoute => GoRouteData.$route(
      path: '/settings',
      factory: $SettingsRouteExtension._fromState,
    );

extension $SettingsRouteExtension on SettingsRoute {
  static SettingsRoute _fromState(GoRouterState state) => SettingsRoute();

  String get location => GoRouteData.$location(
        '/settings',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $changePasswordRoute => GoRouteData.$route(
      path: '/change-password',
      factory: $ChangePasswordRouteExtension._fromState,
    );

extension $ChangePasswordRouteExtension on ChangePasswordRoute {
  static ChangePasswordRoute _fromState(GoRouterState state) =>
      ChangePasswordRoute();

  String get location => GoRouteData.$location(
        '/change-password',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $changePseudoRoute => GoRouteData.$route(
      path: '/change-pseudo',
      factory: $ChangePseudoRouteExtension._fromState,
    );

extension $ChangePseudoRouteExtension on ChangePseudoRoute {
  static ChangePseudoRoute _fromState(GoRouterState state) =>
      ChangePseudoRoute();

  String get location => GoRouteData.$location(
        '/change-pseudo',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $authRoute => GoRouteData.$route(
      path: '/auth',
      factory: $AuthRouteExtension._fromState,
    );

extension $AuthRouteExtension on AuthRoute {
  static AuthRoute _fromState(GoRouterState state) => AuthRoute();

  String get location => GoRouteData.$location(
        '/auth',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $friendDetailsRoute => GoRouteData.$route(
      path: '/friend/:friendId',
      factory: $FriendDetailsRouteExtension._fromState,
    );

extension $FriendDetailsRouteExtension on FriendDetailsRoute {
  static FriendDetailsRoute _fromState(GoRouterState state) =>
      FriendDetailsRoute(
        state.pathParameters['friendId']!,
      );

  String get location => GoRouteData.$location(
        '/friend/${Uri.encodeComponent(friendId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
