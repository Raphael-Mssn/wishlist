import 'package:flutter/material.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/app_wave_pattern.dart';

class WishlistAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WishlistAppBar({
    super.key,
    required this.title,
    required this.wishlistTheme,
    required this.isMyWishlist,
    required this.canShareWishlist,
    required this.onShare,
    required this.onSettings,
  });

  static const double _borderRadius = 32;
  static const double _preferredHeight = 70;

  final String title;
  final ThemeData wishlistTheme;
  final bool isMyWishlist;
  final bool canShareWishlist;
  final VoidCallback onShare;
  final VoidCallback onSettings;

  @override
  Size get preferredSize => const Size.fromHeight(_preferredHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(_borderRadius),
        ),
        child: AppWavePattern(
          backgroundColor: wishlistTheme.primaryColor,
          preset: WavePreset.appBar,
          rotationType: WaveRotationType.fixed,
          rotationAngle: 45,
          child: AppBar(
            backgroundColor: Colors.transparent,
            actions: [
              if (canShareWishlist)
                Padding(
                  padding: EdgeInsets.only(
                    right: isMyWishlist ? 0 : 8,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.share, size: 32),
                    onPressed: onShare,
                  ),
                ),
              if (isMyWishlist)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: const Icon(Icons.settings, size: 32),
                    onPressed: onSettings,
                  ),
                ),
            ],
            foregroundColor: AppColors.background,
            title: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(title, style: AppTextStyles.titleSmall),
            ),
            centerTitle: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(_borderRadius),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
