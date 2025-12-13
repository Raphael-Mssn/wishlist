import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishs/view/widgets/image_upload_field.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/widgets/image_options_bottom_sheet.dart';
import 'package:wishlist/shared/widgets/text_form_fields/app_text_field.dart';
import 'package:wishlist/shared/widgets/text_form_fields/formatters/decimal_text_input_formatter.dart';
import 'package:wishlist/shared/widgets/text_form_fields/validators/not_null_validator.dart';

const _smallGap = Gap(8);
const _columnSpacing = 16.0;

/// Formulaire de création/édition de wish
class WishFormFields extends StatefulWidget {
  const WishFormFields({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.priceController,
    required this.quantityController,
    required this.linkController,
    required this.descriptionController,
    required this.onImageSelected,
    required this.wishlistColor,
    this.existingImageUrl,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController quantityController;
  final TextEditingController linkController;
  final TextEditingController descriptionController;
  final ValueChanged<File?> onImageSelected;
  final Color wishlistColor;
  final String? existingImageUrl;

  @override
  State<WishFormFields> createState() => WishFormFieldsState();
}

class WishFormFieldsState extends State<WishFormFields> {
  File? _selectedImage;
  bool _hasRemovedExistingImage = false;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  late final FocusNode _dummyFocusNode = FocusNode(skipTraversal: true);

  bool get hasRemovedExistingImage => _hasRemovedExistingImage;

  @override
  void dispose() {
    _dummyFocusNode.dispose();
    super.dispose();
  }

  void _focusDummyNode() {
    _dummyFocusNode.requestFocus();
  }

  void enableAutovalidation() {
    if (_autovalidateMode != AutovalidateMode.onUserInteraction) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }

  Future<void> _showImageOptions() async {
    final l10n = context.l10n;
    final existingUrl = widget.existingImageUrl;
    final hasImage = _selectedImage != null ||
        (!_hasRemovedExistingImage &&
            existingUrl != null &&
            existingUrl.isNotEmpty);

    await showImageOptionsBottomSheet(
      context,
      title: l10n.imageOptions,
      hasImage: hasImage,
      onPickFromGallery: _pickImageFromGallery,
      onTakePhoto: _takePhoto,
      onRemoveImage: _removeImage,
      removeImageTitle: l10n.removeImage,
      removeImageConfirmation: l10n.removeImageConfirmation,
    );
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image != null) {
      await _cropImage(image.path);
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image != null) {
      await _cropImage(image.path);
    }
  }

  Future<void> _cropImage(String sourcePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: sourcePath,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Recadrer l'image",
          toolbarColor: widget.wishlistColor,
          toolbarWidgetColor: AppColors.background,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
          ],
          cropFrameColor: widget.wishlistColor,
          cropGridColor: widget.wishlistColor.withValues(alpha: 0.5),
          activeControlsWidgetColor: widget.wishlistColor,
          hideBottomControls: true,
        ),
        IOSUiSettings(
          title: "Recadrer l'image",
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
          ],
          cancelButtonTitle: 'Annuler',
          doneButtonTitle: 'Valider',
          resetAspectRatioEnabled: false,
          aspectRatioPickerButtonHidden: true,
          rotateButtonsHidden: true,
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _selectedImage = File(croppedFile.path);
      });
      widget.onImageSelected(_selectedImage);
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _hasRemovedExistingImage = true;
    });
    widget.onImageSelected(null);
  }

  Future<void> _pasteLink(BuildContext context) async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final text = clipboardData?.text;
    if (text != null) {
      widget.linkController.text = text;
    }
  }

  Future<void> _openLink(BuildContext context) async {
    final link = widget.linkController.text.trim();
    if (link.isEmpty) {
      if (context.mounted) {
        showAppSnackBar(
          context,
          context.l10n.linkNotValid,
          type: SnackBarType.error,
        );
      }
      return;
    }

    try {
      final uri = Uri.parse(link);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(
          context,
          context.l10n.linkNotValid,
          type: SnackBarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Form(
      key: widget.formKey,
      autovalidateMode: _autovalidateMode,
      child: Column(
        spacing: _columnSpacing,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _smallGap,
          AppTextField(
            controller: widget.nameController,
            label: l10n.wishNameLabel,
            icon: Icons.sell_outlined,
            validator: (value) => notNullValidator(value, l10n),
            textCapitalization: TextCapitalization.sentences,
          ),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: widget.priceController,
                  label: l10n.wishPriceLabel,
                  icon: Icons.attach_money,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    DecimalTextInputFormatter(),
                  ],
                ),
              ),
              const Gap(12),
              Expanded(
                child: AppTextField(
                  controller: widget.quantityController,
                  label: l10n.wishQuantityLabel,
                  icon: Icons.one_x_mobiledata,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          AppTextField(
            controller: widget.linkController,
            label: l10n.wishLinkLabel,
            icon: Icons.link,
            keyboardType: TextInputType.url,
            suffixButtons: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.content_paste,
                    size: 20,
                  ),
                  onPressed: () => _pasteLink(context),
                  tooltip: l10n.paste,
                  color: AppColors.makara,
                ),
              ),
              _smallGap,
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.open_in_new,
                    size: 20,
                  ),
                  onPressed: () => _openLink(context),
                  tooltip: l10n.openLink,
                  color: AppColors.makara,
                ),
              ),
            ],
          ),
          AppTextField(
            controller: widget.descriptionController,
            label: l10n.wishDescriptionLabel,
            icon: Icons.description_outlined,
            maxLines: 4,
            minLines: 4,
            textCapitalization: TextCapitalization.sentences,
          ),
          ImageUploadField(
            imageFile: _selectedImage,
            existingImageUrl:
                _hasRemovedExistingImage ? null : widget.existingImageUrl,
            onTap: () {
              _showImageOptions();
              _focusDummyNode();
            },
          ),
          Focus(
            focusNode: _dummyFocusNode,
            child: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
