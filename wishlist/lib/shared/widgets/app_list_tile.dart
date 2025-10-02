import 'package:flutter/material.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isSelected = false,
    this.showCheckmark = false,
    this.iconColor,
    this.textColor,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;
  final bool showCheckmark;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ??
        (isSelected ? Theme.of(context).primaryColor : AppColors.darkGrey);
    final effectiveTextColor = textColor ??
        (isSelected ? Theme.of(context).primaryColor : AppColors.darkGrey);

    return ListTile(
      leading: Icon(
        icon,
        color: effectiveIconColor,
      ),
      title: Text(
        title,
        style: AppTextStyles.small.copyWith(
          color: effectiveTextColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: showCheckmark && isSelected
          ? Icon(
              Icons.check,
              color: Theme.of(context).primaryColor,
            )
          : null,
      onTap: onTap,
    );
  }
}
