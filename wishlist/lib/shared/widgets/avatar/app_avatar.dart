import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/avatar_service.dart';
import 'package:wishlist/shared/theme/colors.dart';

class AppAvatar extends ConsumerWidget {
  const AppAvatar({
    super.key,
    this.avatarUrl,
    required this.size,
    this.showBorder = true,
    this.maskAccountCircleOuter = false,
  });

  final String? avatarUrl;
  final double size;
  final bool showBorder;
  final bool maskAccountCircleOuter;

  static const Color _iconColor = AppColors.background;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullAvatarUrl =
        ref.watch(avatarServiceProvider).getAvatarUrl(avatarUrl);

    if (fullAvatarUrl.isNotEmpty) {
      final Widget avatarImage = ClipOval(
        child: Image.network(
          fullAvatarUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultIcon(),
        ),
      );
      if (showBorder) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.makara,
              width: 4,
            ),
          ),
          child: avatarImage,
        );
      } else {
        return avatarImage;
      }
    }
    return _defaultIcon();
  }

  Widget _defaultIcon() {
    if (maskAccountCircleOuter) {
      // Affiche l'icône account_circle et masque le cercle externe
      // avec une bordure circulaire
      return Stack(
        alignment: Alignment.center,
        children: [
          Transform.scale(
            scale: 1.2,
            child: Icon(
              Icons.account_circle,
              color: _iconColor,
              size: size,
            ),
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.background,
                width: size * 0.1,
              ),
            ),
          ),
        ],
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.makara,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.account_circle,
          color: _iconColor,
          size: size,
        ),
      ),
    );
  }
}
