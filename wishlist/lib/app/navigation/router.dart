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

final router = GoRouter(
  initialLocation: HomeRoute().location,
  refreshListenable: _authStateNotifier,
  routes: $appRoutes,
  redirect: (context, state) {
    final activeSession = supabase.auth.currentSession;
    final isOnForgotPasswordScreen =
        _isOnRoute(state, ForgotPasswordRoute().location);
    final isOnResetPasswordScreen =
        _isOnRoute(state, ResetPasswordRoute().location);

    // Allow access to password recovery screens without authentication
    if (isOnForgotPasswordScreen || isOnResetPasswordScreen) {
      return null;
    }

    if (activeSession == null) {
      return AuthRoute().location;
    }

    final hasPseudo = activeSession.user.userMetadata?.containsKey('pseudo');
    if (hasPseudo == null || !hasPseudo) {
      return PseudoRoute().location;
    }

    return null;
  },
);
