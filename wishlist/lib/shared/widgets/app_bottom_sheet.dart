import 'package:flutter/material.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/widgets/app_wave_pattern.dart';

Future<void> showAppBottomSheet(
  BuildContext context, {
  required Widget body,
  bool expandToFillHeight = true,
}) async {
  const radius = Radius.circular(25);
  // Ensure the theme is the same as the one from the context passed,
  // not the one from the builder of showBarModalBottomSheet
  final theme = Theme.of(context);

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.background,
    barrierColor: Colors.black54.withValues(alpha: 0.3),
    isScrollControlled: true,
    builder: (context) {
      final themedBody = AnimatedTheme(
        data: theme,
        child: body,
      );

      if (expandToFillHeight) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = MediaQuery.of(context).size.height - 80;

            return ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: radius,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: screenHeight,
                ),
                child: Scaffold(body: themedBody),
              ),
            );
          },
        );
      }

      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: radius),
        child: Material(
          color: AppColors.background,
          child: SafeArea(
            top: false,
            child: themedBody,
          ),
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
    this.actionIcon,
    this.onActionTapped,
    this.actionWidget,
    required this.body,
  });

  final ThemeData theme;
  final Widget appBarTitle;
  final IconData? actionIcon;
  final Function()? onActionTapped;
  final Widget? actionWidget;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      data: theme,
      child: Column(
        children: [
          AppWavePattern(
            backgroundColor: theme.primaryColor,
            preset: WavePreset.appBar,
            rotationType: WaveRotationType.fixed,
            rotationAngle: 45,
            height: 70,
            child: AppBar(
              centerTitle: true,
              toolbarHeight: 80,
              backgroundColor: Colors.transparent,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: actionWidget ??
                      IconButton(
                        icon: Icon(
                          actionIcon ?? Icons.more_vert,
                          size: 32,
                        ),
                        onPressed: onActionTapped ?? () {},
                      ),
                ),
              ],
              foregroundColor: AppColors.background,
              title: appBarTitle,
            ),
          ),
          Expanded(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: body,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
