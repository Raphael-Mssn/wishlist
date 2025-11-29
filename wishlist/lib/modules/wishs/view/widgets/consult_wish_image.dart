import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/modules/wishs/view/widgets/consult_box_shadow.dart';
import 'package:wishlist/shared/infra/wish_image_url_provider.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/pill.dart';
import 'package:wishlist/shared/widgets/app_cached_network_image.dart';

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
                      ? _ImageWithTransition(imageUrl: wishImageUrl)
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

class _ImageWithTransition extends StatefulWidget {
  const _ImageWithTransition({
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  State<_ImageWithTransition> createState() => _ImageWithTransitionState();
}

class _ImageWithTransitionState extends State<_ImageWithTransition> {
  bool _isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: kThemeAnimationDuration,
      curve: Curves.easeInOut,
      child: _isLoaded
          ? AppCachedNetworkImage.loaded(
              src: widget.imageUrl,
              fit: BoxFit.contain,
            )
          : CachedNetworkImage(
              imageUrl: widget.imageUrl,
              fit: BoxFit.cover,
              fadeInDuration: kThemeAnimationDuration,
              progressIndicatorBuilder: (_, __, ___) =>
                  const AppCachedNetworkImage.loading(),
              errorWidget: (_, __, ___) => const AppCachedNetworkImage.error(),
              imageBuilder: (context, imageProvider) {
                if (!_isLoaded) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _isLoaded = true;
                      });
                    }
                  });
                }
                return Image(
                  image: imageProvider,
                  fit: BoxFit.cover,
                );
              },
            ),
    );
  }
}
