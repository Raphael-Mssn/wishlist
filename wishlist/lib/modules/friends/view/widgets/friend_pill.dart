import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wishlist/modules/friends/view/widgets/base_avatar_pill.dart';
import 'package:wishlist/shared/models/app_user.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

class FriendPill extends StatelessWidget {
  const FriendPill({
    super.key,
    required this.appUser,
  });

  final AppUser appUser;

  @override
  Widget build(BuildContext context) {
    final textShadow = Shadow(
      color: AppColors.darkGrey.withOpacity(0.3),
      offset: const Offset(2, 2),
      blurRadius: 5,
    );

    const textColor = AppColors.background;

    return BaseAvatarPill(
      backgroundColor: AppColors.primary,
      avatarBorderColor: AppColors.darkOrange,
      child: Padding(
        // This padding is necessary to avoid having text too close to the end
        // of the pill
        padding: const EdgeInsets.symmetric(
          horizontal: 2,
          vertical: 6,
        ).copyWith(right: 12),
        child: Row(
          children: [
            Text(
              appUser.profile.pseudo,
              style: AppTextStyles.small.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
                fontSize: AppTextStyles.small.fontSize,
                shadows: [
                  textShadow,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
