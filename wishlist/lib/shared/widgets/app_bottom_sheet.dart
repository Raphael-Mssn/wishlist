import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wishlist/shared/theme/colors.dart';

Future<void> showAppBottomSheet(
  BuildContext context, {
  required Widget body,
}) async {
  const radius = Radius.circular(25);
  // Ensure the theme is the same as the one from the context passed,
  // not the one from the builder of showBarModalBottomSheet
  final theme = Theme.of(context);

  await showBarModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.background,
    expand: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: radius,
        topRight: radius,
      ),
    ),
    builder: (context) {
      return Scaffold(
        body: AnimatedTheme(
          data: theme,
          child: body,
        ),
      );
    },
  );
}

class AppBottomSheetWithThemeAndAppBarLayout extends StatelessWidget {
  const AppBottomSheetWithThemeAndAppBarLayout({
    super.key,
    required this.theme,
    required this.appBarTitle,
    required this.actionIcon,
    required this.onActionTapped,
    required this.body,
  });

  final ThemeData theme;
  final Widget appBarTitle;
  final IconData actionIcon;
  final Function() onActionTapped;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      data: theme,
      child: Column(
        children: [
          AppBar(
            centerTitle: true,
            toolbarHeight: 80,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: Icon(
                    actionIcon,
                    size: 32,
                  ),
                  onPressed: onActionTapped,
                ),
              ),
            ],
            foregroundColor: AppColors.background,
            title: appBarTitle,
            backgroundColor: theme.primaryColor,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}
