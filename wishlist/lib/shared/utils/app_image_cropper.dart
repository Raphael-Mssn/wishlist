import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:wishlist/shared/theme/colors.dart';

enum AppImageCropMode {
  wish,
  avatar,
}

abstract final class AppImageCropper {
  static const String _cropTitle = "Recadrer l'image";

  static Future<CroppedFile?> cropImage({
    required String sourcePath,
    required AppImageCropMode mode,
    Color? accentColor,
  }) {
    final isAvatar = mode == AppImageCropMode.avatar;
    final effectiveAccentColor = accentColor ?? AppColors.primary;
    final aspectRatioPresets = isAvatar
        ? const [CropAspectRatioPreset.square]
        : const [CropAspectRatioPreset.original];

    return ImageCropper().cropImage(
      sourcePath: sourcePath,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: _cropTitle,
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
          title: _cropTitle,
          cropStyle: isAvatar ? CropStyle.circle : CropStyle.rectangle,
          aspectRatioPresets: aspectRatioPresets,
          cancelButtonTitle: 'Annuler',
          doneButtonTitle: 'Valider',
          resetAspectRatioEnabled: false,
          aspectRatioPickerButtonHidden: true,
          rotateButtonsHidden: true,
        ),
      ],
    );
  }
}
