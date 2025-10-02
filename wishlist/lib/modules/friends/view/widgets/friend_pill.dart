import 'package:flutter/material.dart';
import 'package:wishlist/modules/friends/view/widgets/base_avatar_pill.dart';
import 'package:wishlist/shared/models/app_user.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

class FriendPill extends StatelessWidget {
  const FriendPill({
    super.key,
    required this.appUser,
  });

  final AppUser appUser;

  void _onTap(BuildContext context) {
    FriendDetailsRoute(appUser.user.id).push(context);
  }

  @override
  Widget build(BuildContext context) {
    final textShadow = Shadow(
      color: AppColors.darkGrey.withValues(alpha: 0.3),
      offset: const Offset(2, 2),
      blurRadius: 5,
    );

    const textColor = AppColors.background;

    return BaseAvatarPill(
      onTap: _onTap,
      backgroundColor: AppColors.primary,
      avatarBorderColor: AppColors.darkOrange,
      avatarUrl: appUser.profile.avatarUrl,
      child: Text(
        appUser.profile.pseudo,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.small.copyWith(
          fontWeight: FontWeight.bold,
          color: textColor,
          fontSize: AppTextStyles.small.fontSize,
          shadows: [
            textShadow,
          ],
        ),
      ),
    );
  }
}
