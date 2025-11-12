import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/wish_image_url_provider.dart';
import 'package:wishlist/shared/theme/colors.dart';

/// Widget pour afficher l'image d'un wish
class WishImage extends ConsumerWidget {
  const WishImage({
    super.key,
    required this.iconUrl,
    this.size = 64.0,
    this.borderRadius = 20.0,
    this.thumbnail = true,
  });

  final String? iconUrl;
  final double size;
  final double borderRadius;
  final bool thumbnail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishImageUrl = ref.watch(
      wishImageUrlProvider((imagePath: iconUrl, thumbnail: thumbnail)),
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.gainsboro,
        borderRadius: BorderRadius.circular(borderRadius),
        image: wishImageUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(wishImageUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: wishImageUrl.isEmpty
          ? Icon(
              Icons.card_giftcard,
              size: size / 2,
              color: AppColors.makara.withValues(alpha: 0.3),
            )
          : null,
    );
  }
}
