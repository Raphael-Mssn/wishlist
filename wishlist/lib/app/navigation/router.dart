import 'package:go_router/go_router.dart';
import 'package:wishlist/main.dart';
import 'package:wishlist/shared/navigation/routes.dart';

final router = GoRouter(
  initialLocation: HomeRoute().location,
  routes: $appRoutes,
  redirect: (context, state) {
    final activeSession = supabase.auth.currentSession;
    final isOnResetPasswordScreen =
        state.matchedLocation == ResetPasswordRoute().location;
    final isOnForgotPasswordScreen =
        state.matchedLocation == ForgotPasswordRoute().location;

    // Allow access to password recovery screens without authentication
    if (isOnResetPasswordScreen || isOnForgotPasswordScreen) {
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
