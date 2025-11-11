import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/widgets/app_bottom_sheet.dart';
import 'package:wishlist/shared/widgets/app_list_tile.dart';
import 'package:wishlist/shared/widgets/dialogs/confirm_dialog.dart';

class _ImageOptionsBottomSheet extends StatelessWidget {
  const _ImageOptionsBottomSheet({
    required this.title,
    required this.hasImage,
    required this.onPickFromGallery,
    required this.onTakePhoto,
    required this.onRemoveImage,
    required this.removeImageTitle,
    required this.removeImageConfirmation,
  });

  final String title;
  final bool hasImage;
  final VoidCallback onPickFromGallery;
  final VoidCallback onTakePhoto;
  final VoidCallback onRemoveImage;
  final String removeImageTitle;
  final String removeImageConfirmation;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: AppTextStyles.medium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        AppListTile(
          icon: Icons.photo_library,
          title: l10n.chooseFromGallery,
          onTap: () {
            Navigator.pop(context);
            onPickFromGallery();
          },
        ),
        AppListTile(
          icon: Icons.camera_alt,
          title: l10n.takePhoto,
          onTap: () {
            Navigator.pop(context);
            onTakePhoto();
          },
        ),
        if (hasImage)
          AppListTile(
            icon: Icons.delete,
            title: removeImageTitle,
            onTap: () {
              Navigator.pop(context);
              showConfirmDialog(
                context,
                title: removeImageTitle,
                explanation: removeImageConfirmation,
                onConfirm: () async {
                  onRemoveImage();
                },
              );
            },
          ),
        const Gap(16),
      ],
    );
  }
}

Future<void> showImageOptionsBottomSheet(
  BuildContext context, {
  required String title,
  required bool hasImage,
  required VoidCallback onPickFromGallery,
  required VoidCallback onTakePhoto,
  required VoidCallback onRemoveImage,
  required String removeImageTitle,
  required String removeImageConfirmation,
}) async {
  await showAppBottomSheet(
    context,
    expandToFillHeight: false,
    body: _ImageOptionsBottomSheet(
      title: title,
      hasImage: hasImage,
      onPickFromGallery: onPickFromGallery,
      onTakePhoto: onTakePhoto,
      onRemoveImage: onRemoveImage,
      removeImageTitle: removeImageTitle,
      removeImageConfirmation: removeImageConfirmation,
    ),
  );
}
