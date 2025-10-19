import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/widgets/avatar/app_avatar.dart';

class UserGroupHeader extends StatelessWidget {
  const UserGroupHeader({
    required this.pseudo,
    required this.wishCount,
    this.avatarUrl,
    super.key,
  });

  final String pseudo;
  final String? avatarUrl;
  final int wishCount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        AppAvatar(
          avatarUrl: avatarUrl,
          size: 32,
          hasBorders: avatarUrl == null || avatarUrl!.isEmpty,
        ),
        const Gap(12),
        Expanded(
          child: Text(
            pseudo,
            style: AppTextStyles.medium.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          l10n.bookedWishCount(wishCount),
          style: AppTextStyles.small.copyWith(
            color: AppColors.makara,
          ),
        ),
      ],
    );
  }
}
