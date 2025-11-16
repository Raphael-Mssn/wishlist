// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeRoute,
      $authRoute,
    ];

RouteBase get $homeRoute => GoRouteData.$route(
      path: '/',
      factory: $HomeRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'pseudo',
          factory: $PseudoRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'settings',
          factory: $SettingsRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'change-password',
              factory: $ChangePasswordRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'change-pseudo',
              factory: $ChangePseudoRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'wishlist/:wishlistId',
          factory: $WishlistRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'create-wish',
              factory: $CreateWishRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'wish/:wishId',
              factory: $ConsultWishRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'edit',
                  factory: $EditWishRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'friend/:friendId',
          factory: $FriendDetailsRouteExtension._fromState,
        ),
      ],
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

extension $ChangePasswordRouteExtension on ChangePasswordRoute {
  static ChangePasswordRoute _fromState(GoRouterState state) =>
      ChangePasswordRoute();

  String get location => GoRouteData.$location(
        '/settings/change-password',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ChangePseudoRouteExtension on ChangePseudoRoute {
  static ChangePseudoRoute _fromState(GoRouterState state) =>
      ChangePseudoRoute();

  String get location => GoRouteData.$location(
        '/settings/change-pseudo',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

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

extension $CreateWishRouteExtension on CreateWishRoute {
  static CreateWishRoute _fromState(GoRouterState state) => CreateWishRoute(
        wishlistId: int.parse(state.pathParameters['wishlistId']!),
      );

  String get location => GoRouteData.$location(
        '/wishlist/${Uri.encodeComponent(wishlistId.toString())}/create-wish',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ConsultWishRouteExtension on ConsultWishRoute {
  static ConsultWishRoute _fromState(GoRouterState state) => ConsultWishRoute(
        int.parse(state.pathParameters['wishlistId']!),
        int.parse(state.pathParameters['wishId']!),
        isMyWishlist: _$convertMapValue(
                'is-my-wishlist', state.uri.queryParameters, _$boolConverter) ??
            false,
      );

  String get location => GoRouteData.$location(
        '/wishlist/${Uri.encodeComponent(wishlistId.toString())}/wish/${Uri.encodeComponent(wishId.toString())}',
        queryParams: {
          if (isMyWishlist != false) 'is-my-wishlist': isMyWishlist.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $EditWishRouteExtension on EditWishRoute {
  static EditWishRoute _fromState(GoRouterState state) => EditWishRoute(
        wishlistId: int.parse(state.pathParameters['wishlistId']!),
        wishId: int.parse(state.pathParameters['wishId']!),
      );

  String get location => GoRouteData.$location(
        '/wishlist/${Uri.encodeComponent(wishlistId.toString())}/wish/${Uri.encodeComponent(wishId.toString())}/edit',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

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

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}

RouteBase get $authRoute => GoRouteData.$route(
      path: '/auth',
      factory: $AuthRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'forgot-password',
          factory: $ForgotPasswordRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'reset-password',
          factory: $ResetPasswordRouteExtension._fromState,
        ),
      ],
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

extension $ForgotPasswordRouteExtension on ForgotPasswordRoute {
  static ForgotPasswordRoute _fromState(GoRouterState state) =>
      ForgotPasswordRoute();

  String get location => GoRouteData.$location(
        '/auth/forgot-password',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ResetPasswordRouteExtension on ResetPasswordRoute {
  static ResetPasswordRoute _fromState(GoRouterState state) =>
      ResetPasswordRoute();

  String get location => GoRouteData.$location(
        '/auth/reset-password',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
