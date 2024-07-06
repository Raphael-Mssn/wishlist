import 'package:flutter/material.dart';
import 'package:wishlist/modules/view/home_screen.dart';
import 'package:wishlist/shared/navigation/routes.dart';

MaterialPageRoute<void> onGenerateRoute(RouteSettings settings) =>
    MaterialPageRoute<void>(
      settings: settings,
      builder: (context) {
        final routeName = settings.name;

        if (routeName == AppRoutes.home.name) {
          return const HomeScreen();
        }

        return const SizedBox.shrink();
      },
    );
