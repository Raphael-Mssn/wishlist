import 'package:flutter/material.dart';
import 'package:wishlist/app/navigation/router.dart';
import 'package:wishlist/shared/navigation/routes.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'app',

      onGenerateTitle: (context) => 'Wishlist',

      initialRoute: AppRoutes.home.name,
      // Define a function to handle named routes in order to support
      // Flutter web url navigation and deep linking.
      onGenerateRoute: onGenerateRoute,

      theme: ThemeData(fontFamily: 'Poppins'),
    );
  }
}
