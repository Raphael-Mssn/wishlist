import 'package:flutter/material.dart';
import 'package:wishlist/main.dart';
import 'package:wishlist/modules/auth/view/auth_screen.dart';
import 'package:wishlist/modules/home/view/home_screen.dart';
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

        final routeName = settings.name;

        if (routeName == AppRoutes.home.name) {
          return const HomeScreen();
        }

        if (routeName == AppRoutes.auth.name) {
          return const AuthScreen();
        }

        return const SizedBox.shrink();
      },
    );
