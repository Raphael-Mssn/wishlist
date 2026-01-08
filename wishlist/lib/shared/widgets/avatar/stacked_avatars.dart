import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/widgets/avatar/app_avatar.dart';

/// Widget qui affiche plusieurs avatars stackés (superposés)
/// Utilisé pour montrer plusieurs utilisateurs qui ont réservé un wish
class StackedAvatars extends ConsumerWidget {
  const StackedAvatars({
    super.key,
    required this.avatarUrls,
    this.size = 32,
    this.overlapOffset = 0.6,
    this.maxVisible = 3,
    this.borderWidth = 2,
  });

  final List<String?> avatarUrls;
  final double size;
  final double overlapOffset; // Fraction de chevauchement (0.6 = 60%)
  final int maxVisible; // Nombre maximum d'avatars visibles
  final double borderWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (avatarUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    // Limiter le nombre d'avatars affichés
    final displayedAvatars = avatarUrls.take(maxVisible).toList();
    final hasMore = avatarUrls.length > maxVisible;
    final extraCount = avatarUrls.length - maxVisible;

    // Calculer la largeur totale nécessaire
    final overlapDistance = size * overlapOffset;
    final totalWidth = size +
        (displayedAvatars.length - 1) * overlapDistance +
        (hasMore ? overlapDistance : 0);

    return SizedBox(
      width: totalWidth,
      height: size,
      child: Stack(
        children: [
          // Afficher les avatars en ordre inverse pour avoir le bon z-index
          for (var i = 0; i < displayedAvatars.length; i++)
            Positioned(
              left: i * overlapDistance,
              child: _buildAvatar(displayedAvatars[i]),
            ),
          // Afficher le badge "+X" si nécessaire
          if (hasMore)
            Positioned(
              left: displayedAvatars.length * overlapDistance,
              child: _buildMoreBadge(extraCount),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String? avatarUrl) {
    // Afficher la bordure uniquement pour les avatars par défaut
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.background,
          width: borderWidth,
        ),
      ),
      child: AppAvatar(
        avatarUrl: avatarUrl,
        size: size - (borderWidth * 2),
        hasBorders: !hasAvatar,
      ),
    );
  }

  Widget _buildMoreBadge(int count) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.makara,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.background,
          width: borderWidth,
        ),
      ),
      child: Center(
        child: Text(
          '+$count',
          style: TextStyle(
            color: AppColors.background,
            fontSize: size * 0.35,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
