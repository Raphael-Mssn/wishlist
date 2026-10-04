import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/theme/colors.dart';

enum AppImageCropMode {
  wish,
  avatar,
}

abstract final class AppImageCropper {
  static Future<File?> pickAndCrop({
    required BuildContext context,
    required ImageSource source,
    required AppImageCropMode mode,
    Color? accentColor,
  }) async {
    final image = await ImagePicker().pickImage(source: source);

    if (image == null || !context.mounted) {
      return null;
    }

    final croppedImage = await cropImage(
      context: context,
      sourcePath: image.path,
      mode: mode,
      accentColor: accentColor,
    );

    return croppedImage == null ? null : File(croppedImage.path);
  }

  static Future<CroppedFile?> cropImage({
    required BuildContext context,
    required String sourcePath,
    required AppImageCropMode mode,
    Color? accentColor,
  }) {
    final l10n = context.l10n;
    final isAvatar = mode == AppImageCropMode.avatar;
    final effectiveAccentColor = accentColor ?? AppColors.primary;
    final cropStyle = isAvatar ? CropStyle.circle : CropStyle.rectangle;
    final aspectRatioPreset = isAvatar
        ? CropAspectRatioPreset.square
        : CropAspectRatioPreset.original;
    final aspectRatioPresets = isAvatar
        ? const [CropAspectRatioPreset.square]
        : const [CropAspectRatioPreset.original];
    final maxDimension = isAvatar ? 800 : 1024;

    return ImageCropper().cropImage(
      sourcePath: sourcePath,
      maxWidth: maxDimension,
      maxHeight: maxDimension,
      compressQuality: 85,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: l10n.cropImageTitle,
          toolbarColor: effectiveAccentColor,
          statusBarLight:
              AppColors.darken(effectiveAccentColor).computeLuminance() > 0.5,
          toolbarWidgetColor: AppColors.background,
          cropStyle: cropStyle,
          initAspectRatio: aspectRatioPreset,
          lockAspectRatio: isAvatar,
          aspectRatioPresets: aspectRatioPresets,
          cropFrameColor: effectiveAccentColor,
          cropGridColor: effectiveAccentColor.withValues(alpha: 0.5),
          activeControlsWidgetColor: effectiveAccentColor,
          hideBottomControls: true,
        ),
        IOSUiSettings(
          title: l10n.cropImageTitle,
          cropStyle: cropStyle,
          aspectRatioPresets: aspectRatioPresets,
          aspectRatioLockEnabled: isAvatar,
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
