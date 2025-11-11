import 'package:flutter/material.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/app_wave_pattern.dart';
import 'package:wishlist/shared/theme/widgets/favourite_button.dart';

/// AppBar personnalisé pour l'écran de création de wish
class CreateWishAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CreateWishAppBar({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.isFavourite,
    required this.onFavouriteTap,
  });

  final String title;
  final Color backgroundColor;
  final bool isFavourite;
  final Future<bool> Function({required bool isLiked}) onFavouriteTap;

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
        child: AppWavePattern(
          backgroundColor: backgroundColor,
          preset: WavePreset.appBar,
          rotationType: WaveRotationType.fixed,
          rotationAngle: 45,
          child: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.background,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                title,
                style: AppTextStyles.medium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            centerTitle: true,
            actions: [
              FavouriteButton(
                isLiked: isFavourite,
                onTap: onFavouriteTap,
              ),
            ],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
