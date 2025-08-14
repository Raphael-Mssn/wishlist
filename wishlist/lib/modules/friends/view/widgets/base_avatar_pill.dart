import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/modules/friends/view/widgets/default_avatar_icon.dart';
import 'package:wishlist/shared/infra/avatar_service.dart';
import 'package:wishlist/shared/theme/colors.dart';

class BaseAvatarPill extends ConsumerWidget {
  const BaseAvatarPill({
    super.key,
    required this.backgroundColor,
    required this.avatarBorderColor,
    required this.child,
    required this.onTap,
    this.avatarUrl,
  });

  final Color backgroundColor;
  final Color avatarBorderColor;
  final Widget child;
  final void Function(BuildContext) onTap;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const avatarSize = 64.0;
    const borderRadius = BorderRadius.all(
      Radius.circular(50),
    );

    final fullAvatarUrl =
        ref.watch(avatarServiceProvider).getAvatarUrl(avatarUrl);

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
                if (fullAvatarUrl.isNotEmpty)
                  ClipOval(
                    child: CircleAvatar(
                      radius: (avatarSize - 12) / 2, // Suppression border
                      backgroundColor: AppColors.makara,
                      backgroundImage: NetworkImage(fullAvatarUrl),
                    ),
                  )
                else
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
