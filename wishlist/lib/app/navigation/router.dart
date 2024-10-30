import 'package:go_router/go_router.dart';
import 'package:wishlist/main.dart';
import 'package:wishlist/shared/navigation/routes.dart';

final router = GoRouter(
  initialLocation: HomeRoute().location,
  routes: $appRoutes,
  redirect: (context, state) {
    final activeSession = supabase.auth.currentSession;
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
