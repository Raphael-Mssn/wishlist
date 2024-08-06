import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/app/config/environment.dart';
import 'package:wishlist/app/config/environment_provider.dart';
import 'package:wishlist/shared/infra/auth_api.dart';

class AppScaffold extends ConsumerWidget {
  const AppScaffold({
    super.key,
    required this.bottomNavigationBar,
    required this.floatingActionButton,
    required this.body,
  });

  final Widget bottomNavigationBar;
  final Widget floatingActionButton;
  final Widget body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // TODO: Remove this button when we have a proper logout flow
          if (ref.watch(environmentProvider) == Environment.dev)
            ElevatedButton(
              onPressed: () {
                ref.read(authApiProvider).signOut(context);
              },
              child: const Text('Logout'),
            ),
          body,
          Positioned(
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(child: bottomNavigationBar),
                  const Gap(32),
                  floatingActionButton,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
