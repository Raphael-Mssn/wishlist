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
    this.onTap,
    super.key,
  });

  final String pseudo;
  final String? avatarUrl;
  final int wishCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final avatarUrl = this.avatarUrl ?? '';

    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    AppAvatar(
                      avatarUrl: avatarUrl,
                      size: 32,
                      hasBorders: avatarUrl.isEmpty,
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
                  ],
                ),
              ),
            ),
          ),
        ),
        const Gap(8),
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
