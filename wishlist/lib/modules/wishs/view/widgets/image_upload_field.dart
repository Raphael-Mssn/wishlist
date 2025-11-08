import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

/// Widget pour uploader une image avec un design moderne
class ImageUploadField extends StatelessWidget {
  const ImageUploadField({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.gainsboro,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Column(
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
          ),
        ),
      ),
    );
  }
}
