import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/widgets/app_cached_network_image.dart';

class ImageUploadField extends StatelessWidget {
  const ImageUploadField({
    super.key,
    this.onTap,
    this.imageFile,
    this.existingImageUrl,
  });

  final VoidCallback? onTap;
  final File? imageFile;
  final String? existingImageUrl;

  static const double _imageHeight = 180;
  static const double _borderRadius = 16;

  bool get _hasImage {
    final existingUrl = existingImageUrl;
    return imageFile != null || (existingUrl != null && existingUrl.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final existingUrl = existingImageUrl;
    final image = imageFile;

    final content = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: !_hasImage
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 48,
                    color: AppColors.makara.withValues(alpha: 0.6),
                  ),
                  const Gap(12),
                  Text(
                    l10n.uploadImage,
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.makara,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.white,
                      ),
                      const Gap(8),
                      Text(
                        l10n.uploadImage,
                        style: AppTextStyles.small.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );

    if (image != null) {
      return Container(
        height: _imageHeight,
        decoration: BoxDecoration(
          color: AppColors.gainsboro,
          borderRadius: BorderRadius.circular(_borderRadius),
          image: DecorationImage(
            image: FileImage(image),
            fit: BoxFit.cover,
          ),
        ),
        child: content,
      );
    }

    if (existingUrl != null && existingUrl.isNotEmpty) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(_borderRadius),
            child: Container(
              width: double.infinity,
              height: _imageHeight,
              color: AppColors.gainsboro,
              child: AppCachedNetworkImage.loaded(
                src: existingUrl,
                height: _imageHeight,
                fit: BoxFit.cover,
                placeholderColor: AppColors.gainsboro,
              ),
            ),
          ),
          Positioned.fill(
            child: content,
          ),
        ],
      );
    }

    return Container(
      height: _imageHeight,
      decoration: BoxDecoration(
        color: AppColors.gainsboro,
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: content,
    );
  }
}
