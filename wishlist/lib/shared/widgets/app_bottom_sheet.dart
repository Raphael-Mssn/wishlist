import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

Future<void> showAppBottomSheet(
  BuildContext context, {
  required Widget body,
}) async {
  const radius = Radius.circular(25);

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
      return Scaffold(body: body);
    },
  );
}

class AppBottomSheetWithThemeAndAppBarLayout extends StatelessWidget {
  const AppBottomSheetWithThemeAndAppBarLayout({
    super.key,
    required this.theme,
    required this.title,
    required this.actionIcon,
    required this.onActionTapped,
    required this.body,
  });

  final ThemeData theme;
  final String title;
  final Icon actionIcon;
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
                  icon: actionIcon,
                  onPressed: onActionTapped,
                ),
              ),
            ],
            foregroundColor: AppColors.background,
            title: Text(
              title,
              style: AppTextStyles.medium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
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
