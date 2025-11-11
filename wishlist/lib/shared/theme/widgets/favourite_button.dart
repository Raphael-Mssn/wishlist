import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:wishlist/shared/theme/colors.dart';

/// Wrapper réutilisable autour de `LikeButton` utilisé dans l'app.
class FavouriteButton extends StatelessWidget {
  const FavouriteButton({
    super.key,
    required this.isLiked,
    required this.onTap,
    this.size = 32.0,
    this.padding = const EdgeInsets.only(right: 12),
  });

  final bool isLiked;
  final double size;
  final EdgeInsetsGeometry padding;
  final Future<bool> Function({required bool isLiked}) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: LikeButton(
        isLiked: isLiked,
        size: size,
        likeBuilder: (isLiked) {
          return Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: AppColors.background,
            size: size,
          );
        },
        onTap: (isLiked) => onTap(isLiked: isLiked),
      ),
    );
  }
}
