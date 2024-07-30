import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AppScaffold extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          body,
          Positioned(
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
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
