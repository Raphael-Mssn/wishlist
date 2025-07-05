import 'package:flutter/material.dart';
import 'package:wishlist/modules/friends/view/widgets/default_avatar_icon.dart';
import 'package:wishlist/shared/theme/colors.dart';

class BaseAvatarPill extends StatelessWidget {
  const BaseAvatarPill({
    super.key,
    required this.backgroundColor,
    required this.avatarBorderColor,
    required this.child,
    required this.onTap,
  });

  final Color backgroundColor;
  final Color avatarBorderColor;
  final Widget child;
  final void Function(BuildContext) onTap;

  @override
  Widget build(BuildContext context) {
    const avatarSize = 64.0;
    const borderRadius = BorderRadius.all(
      Radius.circular(50),
    );

    return InkWell(
      onTap: () => onTap(context),
      borderRadius: borderRadius,
      child: Ink(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Row(
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: avatarSize,
                  width: avatarSize,
                  decoration: BoxDecoration(
                    color: AppColors.makara,
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: avatarBorderColor,
                        width: 6,
                      ),
                    ),
                  ),
                ),
                // TODO: Add avatar
                const DefaultAvatarIcon(
                  color: AppColors.background,
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
