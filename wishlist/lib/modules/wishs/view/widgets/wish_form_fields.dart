import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishs/view/widgets/image_upload_field.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/utils/app_image_cropper.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/utils/link_utils.dart';
import 'package:wishlist/shared/widgets/image_options_bottom_sheet.dart';
import 'package:wishlist/shared/widgets/text_form_fields/app_text_field.dart';
import 'package:wishlist/shared/widgets/text_form_fields/formatters/decimal_text_input_formatter.dart';
import 'package:wishlist/shared/widgets/text_form_fields/validators/not_null_validator.dart';

const _smallGap = Gap(8);
const _columnSpacing = 16.0;
const wishNameMaxLength = 80;

/// Ramène un nom prérempli (partage, titre de page) à [wishNameMaxLength]
/// caractères : la limite du champ ne s'applique qu'à la saisie au clavier.
String truncateWishName(String name) {
  final trimmed = name.trim();
  if (trimmed.length <= wishNameMaxLength) {
    return trimmed;
  }
  return trimmed.substring(0, wishNameMaxLength).trimRight();
}

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
    this.linkFocusNode,
    this.onLinkPasted,
    this.existingImageUrl,
    this.initialImageFile,
    this.isPreviewImageLoading = false,
    this.initialNameFromPreview,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController quantityController;
  final TextEditingController linkController;
  final TextEditingController descriptionController;
  final ValueChanged<File?> onImageSelected;
  final Color wishlistColor;

  /// FocusNode du champ lien, possédé par l'écran parent.
  final FocusNode? linkFocusNode;

  /// Appelé quand l'utilisateur colle un lien via le bouton.
  final VoidCallback? onLinkPasted;

  final String? existingImageUrl;

  /// Image reçue via partage (ex. Amazon) : affichée dans le formulaire.
  final File? initialImageFile;

  /// True pendant le chargement de l'aperçu du lien (og:image / Microlink).
  final bool isPreviewImageLoading;

  /// Titre de la page (og:title) : préremplit le nom quand vide.
  final String? initialNameFromPreview;

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
  void initState() {
    super.initState();
    if (widget.initialImageFile != null) {
      _selectedImage = widget.initialImageFile;
    }
    if (widget.initialNameFromPreview != null &&
        widget.initialNameFromPreview!.isNotEmpty &&
        widget.nameController.text.trim().isEmpty) {
      widget.nameController.text =
          truncateWishName(widget.initialNameFromPreview!);
    }
  }

  @override
  void didUpdateWidget(covariant WishFormFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newFile = widget.initialImageFile;
    if (newFile != null && newFile.path != _selectedImage?.path) {
      setState(() => _selectedImage = newFile);
    }
    final nameFromPreview = widget.initialNameFromPreview;
    if (nameFromPreview != null &&
        nameFromPreview.isNotEmpty &&
        nameFromPreview != oldWidget.initialNameFromPreview &&
        widget.nameController.text.trim().isEmpty) {
      widget.nameController.text = truncateWishName(nameFromPreview);
    }
  }

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
    await _pickAndCropImage(ImageSource.gallery);
  }

  Future<void> _takePhoto() async {
    await _pickAndCropImage(ImageSource.camera);
  }

  Future<void> _pickAndCropImage(ImageSource source) async {
    try {
      final image = await AppImageCropper.pickAndCrop(
        context: context,
        source: source,
        mode: AppImageCropMode.wish,
        accentColor: widget.wishlistColor,
      );

      if (!mounted || image == null) {
        return;
      }

      setState(() {
        _selectedImage = image;
      });
      widget.onImageSelected(_selectedImage);
    } on PlatformException {
      if (!mounted) {
        return;
      }

      showAppSnackBar(
        context,
        context.l10n.genericError,
        type: SnackBarType.error,
      );
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
      widget.onLinkPasted?.call();
    }
  }

  Future<void> _openLink(BuildContext context) async {
    final uri = parseWebLink(widget.linkController.text);

    var isLaunched = false;
    if (uri != null) {
      try {
        isLaunched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {
        isLaunched = false;
      }
    }

    if (!isLaunched && context.mounted) {
      showAppSnackBar(
        context,
        context.l10n.linkNotValid,
        type: SnackBarType.error,
      );
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
            maxLength: wishNameMaxLength,
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
            focusNode: widget.linkFocusNode,
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
            isPreviewLoading: widget.isPreviewImageLoading,
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
