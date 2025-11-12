import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

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

  bool get _hasImage =>
      imageFile != null ||
      (existingImageUrl != null && existingImageUrl!.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    DecorationImage? backgroundImage;

    if (imageFile != null) {
      // Priorité à l'image locale (nouveau fichier sélectionné)
      backgroundImage = DecorationImage(
        image: FileImage(imageFile!),
        fit: BoxFit.cover,
      );
    } else if (existingImageUrl != null && existingImageUrl!.isNotEmpty) {
      // Sinon, afficher l'image existante du serveur
      backgroundImage = DecorationImage(
        image: NetworkImage(existingImageUrl!),
        fit: BoxFit.cover,
      );
    }

    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.gainsboro,
        borderRadius: BorderRadius.circular(16),
        image: backgroundImage,
      ),
      child: Material(
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
      ),
    );
  }
}
