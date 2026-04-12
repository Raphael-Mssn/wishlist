import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/theme/colors.dart';

enum AppImageCropMode {
  wish,
  avatar,
}

abstract final class AppImageCropper {
  static Future<CroppedFile?> cropImage({
    required BuildContext context,
    required String sourcePath,
    required AppImageCropMode mode,
    Color? accentColor,
  }) {
    final l10n = context.l10n;
    final isAvatar = mode == AppImageCropMode.avatar;
    final effectiveAccentColor = accentColor ?? AppColors.primary;
    final aspectRatioPresets = isAvatar
        ? const [CropAspectRatioPreset.square]
        : const [CropAspectRatioPreset.original];

    return ImageCropper().cropImage(
      sourcePath: sourcePath,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: l10n.cropImageTitle,
          toolbarColor: effectiveAccentColor,
          toolbarWidgetColor: AppColors.background,
          cropStyle: isAvatar ? CropStyle.circle : CropStyle.rectangle,
          initAspectRatio: isAvatar
              ? CropAspectRatioPreset.square
              : CropAspectRatioPreset.original,
          lockAspectRatio: false,
          aspectRatioPresets: aspectRatioPresets,
          cropFrameColor: effectiveAccentColor,
          cropGridColor: effectiveAccentColor.withValues(alpha: 0.5),
          activeControlsWidgetColor: effectiveAccentColor,
          hideBottomControls: true,
        ),
        IOSUiSettings(
          title: l10n.cropImageTitle,
          cropStyle: isAvatar ? CropStyle.circle : CropStyle.rectangle,
          aspectRatioPresets: aspectRatioPresets,
          cancelButtonTitle: l10n.cropImageCancel,
          doneButtonTitle: l10n.cropImageValidate,
          resetAspectRatioEnabled: false,
          aspectRatioPickerButtonHidden: true,
          rotateButtonsHidden: true,
        ),
      ],
    );
  }
}
