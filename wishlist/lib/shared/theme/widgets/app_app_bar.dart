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
    final isFirstRoute = ModalRoute.of(context)?.isFirst ?? true;
    // We allow "!" usage here because we know that the fontSize is not null
    final titleSize = isFirstRoute
        ? AppTextStyles.title.fontSize
        : AppTextStyles.title.fontSize! - 4;

    final actions = [
      if (isFirstRoute)
        IconButton(
          icon: const Icon(
            Icons.settings,
            color: AppColors.darkGrey,
            size: 32,
          ),
          onPressed: () => SettingsRoute().push(context),
        ),
    ];

    return AppBar(
      centerTitle: false,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.background,
      actions: actions,
      actionsPadding: const EdgeInsets.only(right: 12),
      flexibleSpace: SafeArea(
        child: Padding(
          // Padding symétrique de 56 pour centrer par rapport à l'écran
          // (56 ≈ largeur du bouton retour ou du bouton settings)
          padding: EdgeInsets.symmetric(horizontal: isFirstRoute ? 20 : 56),
          child: Align(
            alignment: isFirstRoute ? Alignment.centerLeft : Alignment.center,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: AppTextStyles.title.copyWith(fontSize: titleSize),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
