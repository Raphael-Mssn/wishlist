import 'package:flutter/material.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    // We allow "!" usage here because we know that the fontSize is not null
    final titleSize = canPop
        ? AppTextStyles.title.fontSize! - 4
        : AppTextStyles.title.fontSize;

    return AppBar(
      centerTitle: canPop,
      titleSpacing: 0,
      backgroundColor: AppColors.background,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          title,
          style: AppTextStyles.title.copyWith(fontSize: titleSize),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
