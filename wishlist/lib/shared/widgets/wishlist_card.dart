import 'package:flutter/material.dart';
import 'package:pattern_box/pattern_box.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/angled_wave_painter.dart';
import 'package:wishlist/shared/theme/widgets/rotatable_pattern_box.dart';

class WishlistCard extends StatelessWidget {
  const WishlistCard({
    super.key,
    required this.wishlist,
    required this.color,
  });

  final Wishlist wishlist;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(36);

    // north, east, south, west
    final randomRotationAngleDegrees = wishlist.id % 4 * 90;

    void onTap() {
      WishlistRoute(wishlistId: wishlist.id).push(context);
    }

    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        highlightColor: AppColors.darken(color),
        child: Ink(
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
          ),
          child: PatternBoxWidget(
            pattern: WavePainter(
              frequency: 0.8,
              thickness: 16,
              gap: 48,
              color: AppColors.lighten(color),
              amplitude: 20,
            )
                .withAngleVariation(
                  angleVariation: 0.2,
                )
                .rotatedDegrees(randomRotationAngleDegrees.toDouble()),
            borderRadius: borderRadius,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        wishlist.name,
                        style: AppTextStyles.medium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
