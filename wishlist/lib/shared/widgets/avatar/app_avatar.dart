import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/avatar_service.dart';
import 'package:wishlist/shared/infra/presence_provider.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/widgets/avatar/online_indicator.dart';

class AppAvatar extends ConsumerWidget {
  const AppAvatar({
    super.key,
    this.avatarUrl,
    required this.size,
    this.hasBorders = true,
    this.userId,
    this.showOnlineIndicator = false,
  });

  final String? avatarUrl;
  final double size;
  final bool hasBorders;
  final String? userId;
  final bool showOnlineIndicator;

  static const Color _iconColor = AppColors.background;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullAvatarUrl =
        ref.watch(avatarServiceProvider).getAvatarUrl(avatarUrl);

    final userId = this.userId;
    final isOnline = showOnlineIndicator &&
        userId != null &&
        ref.watch(isUserOnlineProvider(userId));

    Widget avatarWidget;

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
      if (hasBorders) {
        avatarWidget = Container(
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
        avatarWidget = avatarImage;
      }
    } else {
      avatarWidget = _defaultIcon();
    }

    // Ajouter l'indicateur de présence si nécessaire
    if (isOnline) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          avatarWidget,
          Positioned(
            right: 0,
            bottom: 0,
            child: OnlineIndicator(
              size: size * 0.25, // 25% de la taille de l'avatar
            ),
          ),
        ],
      );
    }

    return avatarWidget;
  }

  Widget _defaultIcon() {
    if (hasBorders) {
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
}
