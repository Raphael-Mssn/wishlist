import 'package:flutter/material.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final isFirstRoute = ModalRoute.of(context)?.isFirst ?? false;
    // We allow "!" usage here because we know that the fontSize is not null
    final titleSize = isFirstRoute
        ? AppTextStyles.title.fontSize
        : AppTextStyles.title.fontSize! - 4;

    final actions = [
      if (isFirstRoute)
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => SettingsRoute().push(context),
        ),
    ];

    return AppBar(
      centerTitle: !isFirstRoute,
      titleSpacing: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.background,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          title,
          style: AppTextStyles.title.copyWith(fontSize: titleSize),
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
