import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

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
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          body,
          Positioned(
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              width: MediaQuery.sizeOf(context).width,
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
