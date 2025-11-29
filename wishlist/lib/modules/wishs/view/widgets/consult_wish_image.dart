import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/modules/wishs/view/widgets/consult_box_shadow.dart';
import 'package:wishlist/shared/infra/wish_image_url_provider.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/pill.dart';

class ConsultWishImage extends ConsumerWidget {
  const ConsultWishImage({
    super.key,
    required this.wish,
  });

  final Wish wish;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishImageUrl = ref.watch(
      wishImageUrlProvider((imagePath: wish.iconUrl, thumbnail: false)),
    );

    const imageNotFound = Icon(
      Icons.image_not_supported,
      size: 128,
    );

    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    consultBoxShadow,
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: wishImageUrl.isNotEmpty
                      ? Image.network(
                          wishImageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return imageNotFound;
                          },
                        )
                      : imageNotFound,
                ),
              ),
              if (wish.quantity > 1)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Pill(
                    text: 'x${wish.quantity}',
                    backgroundColor: Theme.of(context).primaryColor,
                    textStyle: AppTextStyles.medium,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
