import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/avatar_service.dart';
import 'package:wishlist/shared/theme/colors.dart';

class AvatarWidget extends ConsumerWidget {
  const AvatarWidget({
    super.key,
    this.avatarUrl,
    this.radius = 24,
  });

  final String? avatarUrl;
  final double radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarService = ref.watch(avatarServiceProvider);

    final fullAvatarUrl = avatarService.getAvatarUrl(avatarUrl);
    final hasValidUrl = fullAvatarUrl.isNotEmpty;

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.makara,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: radius - 2,
        backgroundColor: AppColors.makara,
        backgroundImage: hasValidUrl ? NetworkImage(fullAvatarUrl) : null,
        child: hasValidUrl
            ? null
            : Icon(
                Icons.person,
                size: radius * 1.2,
                color: AppColors.background,
              ),
      ),
    );
  }
}
