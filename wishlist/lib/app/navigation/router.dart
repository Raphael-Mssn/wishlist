import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishlist/main.dart';
import 'package:wishlist/shared/navigation/routes.dart';

class AuthStateNotifier extends ChangeNotifier {
  AuthStateNotifier() {
    supabase.auth.onAuthStateChange.listen((data) {
      notifyListeners();
    });
  }
}

final _authStateNotifier = AuthStateNotifier();

bool _isOnRoute(GoRouterState state, String routeLocation) {
  return routeLocation.split('/').last == state.matchedLocation.split('/').last;
}

String? _sanitizeRedirectTarget(String? target) {
  if (target == null || target.isEmpty) {
    return null;
  }

  final uri = Uri.tryParse(target);
  if (uri == null) {
    return null;
  }

  if (!uri.hasScheme && !uri.hasAuthority) {
    if (!target.startsWith('/')) {
      return null;
    }

    return target;
  }

  final isWishyDeepLink =
      uri.scheme == 'wishy' && uri.host == 'com.raphtang.wishy';

  if (!isWishyDeepLink || !uri.path.startsWith('/')) {
    return null;
  }

  return Uri(
    path: uri.path,
    queryParameters: uri.queryParameters.isEmpty ? null : uri.queryParameters,
  ).toString();
}

String _buildLocationWithRedirectTo(
  String baseLocation,
  String redirectTo,
) {
  return Uri(
    path: baseLocation,
    queryParameters: {
      'redirectTo': redirectTo,
    },
  ).toString();
}

final router = GoRouter(
  initialLocation: HomeRoute().location,
  refreshListenable: _authStateNotifier,
  routes: $appRoutes,
  redirect: (context, state) {
    final activeSession = supabase.auth.currentSession;
    final redirectTo = _sanitizeRedirectTarget(
      state.uri.queryParameters['redirectTo'],
    );
    final currentLocation = state.uri.toString();
    final currentTarget = _sanitizeRedirectTarget(currentLocation);

    final isOnAuthScreen = _isOnRoute(state, AuthRoute().location);
    final isOnPseudoScreen = _isOnRoute(state, PseudoRoute().location);
    final isOnForgotPasswordScreen =
        _isOnRoute(state, ForgotPasswordRoute().location);
    final isOnResetPasswordScreen =
        _isOnRoute(state, ResetPasswordRoute().location);

    // Allow access to password recovery screens without authentication
    if (isOnForgotPasswordScreen || isOnResetPasswordScreen) {
      return null;
    }

    if (activeSession == null) {
      if (isOnAuthScreen) {
        return null;
      }

      if (currentTarget == null) {
        return AuthRoute().location;
      }

      return _buildLocationWithRedirectTo(
        AuthRoute().location,
        currentTarget,
      );
    }

    final hasPseudo = activeSession.user.userMetadata?.containsKey('pseudo');
    if (hasPseudo == null || !hasPseudo) {
      if (isOnPseudoScreen) {
        return null;
      }

      if (redirectTo != null) {
        return _buildLocationWithRedirectTo(
          PseudoRoute().location,
          redirectTo,
        );
      }

      return PseudoRoute().location;
    }

    if (isOnAuthScreen || isOnPseudoScreen) {
      return redirectTo ?? HomeRoute().location;
    }

    return null;
  },
);
