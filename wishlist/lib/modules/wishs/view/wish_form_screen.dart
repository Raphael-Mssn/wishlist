import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishs/view/widgets/wish_form_app_bar.dart';
import 'package:wishlist/modules/wishs/view/widgets/wish_form_fields.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_streams_providers.dart';
import 'package:wishlist/shared/infra/wish_image_url_provider.dart';
import 'package:wishlist/shared/infra/wish_mutations_provider.dart';
import 'package:wishlist/shared/models/wish/create_request/wish_create_request.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/providers/wishlist_theme_provider.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/utils/double_extension.dart';
import 'package:wishlist/shared/widgets/dialogs/app_dialog.dart';

class WishFormScreen extends ConsumerStatefulWidget {
  const WishFormScreen({
    super.key,
    required this.wishlistId,
    this.wish,
  });

  final int wishlistId;
  final Wish? wish;

  bool get isEditMode => wish != null;

  @override
  ConsumerState<WishFormScreen> createState() => _WishFormScreenState();
}

class _WishFormScreenState extends ConsumerState<WishFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _wishFormFieldsKey = GlobalKey<WishFormFieldsState>();

  late TextEditingController _nameInputController;
  late TextEditingController _priceInputController;
  late TextEditingController _quantityInputController;
  late TextEditingController _linkInputController;
  late TextEditingController _descriptionInputController;

  late bool _isFavourite;
  bool _isLoading = false;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();

    final wish = widget.wish;
    if (wish != null) {
      // Mode édition : initialiser avec les valeurs du wish
      final price = wish.price;
      _nameInputController = TextEditingController(text: wish.name);
      _priceInputController = TextEditingController(
        text: price.toStringWithout0OrEmpty(),
      );
      _quantityInputController =
          TextEditingController(text: wish.quantity.toString());
      _linkInputController = TextEditingController(text: wish.linkUrl);
      _descriptionInputController =
          TextEditingController(text: wish.description);
      _isFavourite = wish.isFavourite;
    } else {
      // Mode création : initialiser avec des valeurs par défaut
      _nameInputController = TextEditingController();
      _priceInputController = TextEditingController();
      _quantityInputController = TextEditingController(text: '1');
      _linkInputController = TextEditingController();
      _descriptionInputController = TextEditingController();
      _isFavourite = false;
    }
  }

  void _onImageSelected(File? imageFile) {
    setState(() {
      _selectedImage = imageFile;
    });
  }

  bool _validateQuantity(int? quantity) {
    if (!widget.isEditMode || quantity == null) {
      return true;
    }

    final wish = widget.wish!;
    // La quantité ne peut pas être inférieure à la quantité déjà réservée
    if (quantity < wish.totalBookedQuantity) {
      showAppSnackBar(
        context,
        context.l10n.quantityCannotBeLowerThanBooked(
          wish.totalBookedQuantity,
        ),
        type: SnackBarType.error,
      );
      return false;
    }

    return true;
  }

  Future<void> _onSubmit() async {
    // Activer la validation automatique après la première tentative
    _wishFormFieldsKey.currentState?.enableAutovalidation();

    if (!_formKey.currentState!.validate()) {
      showAppSnackBar(
        context,
        context.l10n.wishNameError,
        type: SnackBarType.error,
      );
      return;
    }

    final name = _nameInputController.text;
    final price = _priceInputController.text.replaceAll(',', '.');
    final quantity = int.tryParse(_quantityInputController.text);
    final link = _linkInputController.text;
    final description = _descriptionInputController.text;

    if (!_validateQuantity(quantity)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.isEditMode) {
        await _updateWish(name, price, quantity, link, description);
      } else {
        await _createWish(name, price, quantity, link, description);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _createWish(
    String name,
    String price,
    int? quantity,
    String link,
    String description,
  ) async {
    final wishlistAsync =
        ref.read(watchWishlistByIdProvider(widget.wishlistId));

    wishlistAsync.whenData((wishlist) async {
      final wish = WishCreateRequest(
        name: name,
        price: double.tryParse(price),
        quantity: quantity,
        description: description,
        wishlistId: widget.wishlistId,
        updatedBy: wishlist.idOwner,
        linkUrl: link,
        isFavourite: _isFavourite,
      );

      try {
        if (_selectedImage != null) {
          await ref.read(wishMutationsProvider.notifier).createWithImage(
                request: wish,
                imageFile: _selectedImage,
              );
        } else {
          await ref.read(wishMutationsProvider.notifier).create(wish);
        }

        if (mounted) {
          showAppSnackBar(
            context,
            context.l10n.createWishSuccess,
            type: SnackBarType.success,
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          showGenericError(context);
        }
      }
    });
  }

  Future<void> _updateWish(
    String name,
    String price,
    int? quantity,
    String link,
    String description,
  ) async {
    final wish = widget.wish!;

    final wishToUpdate = wish.copyWith(
      name: name,
      price: double.tryParse(price),
      quantity: quantity,
      description: description,
      linkUrl: link,
      isFavourite: _isFavourite,
    );

    try {
      final hasRemovedImage =
          _wishFormFieldsKey.currentState?.hasRemovedExistingImage ?? false;

      // Utiliser updateWithImage pour tous les cas où l'image change
      if (_selectedImage != null || hasRemovedImage) {
        await ref.read(wishMutationsProvider.notifier).updateWithImage(
              wish: wishToUpdate,
              imageFile: _selectedImage,
              deleteImage: hasRemovedImage && _selectedImage == null,
            );
      } else {
        // Sinon, update sans changement d'image
        await ref.read(wishMutationsProvider.notifier).update(wishToUpdate);
      }

      if (mounted) {
        showAppSnackBar(
          context,
          context.l10n.updateSuccess,
          type: SnackBarType.success,
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        showGenericError(context);
      }
    }
  }

  void _onDeleteWish() {
    final l10n = context.l10n;

    showAppDialog(
      context,
      title: l10n.deleteWish,
      content: Text(
        l10n.deleteWishConfirmationMessage,
        style: AppTextStyles.small.copyWith(
          color: AppColors.makara,
        ),
      ),
      confirmButtonLabel: l10n.confirmDialogConfirmButtonLabel,
      onConfirm: () async {
        try {
          await ref.read(wishMutationsProvider.notifier).delete(
                widget.wish!.id,
                iconUrl: widget.wish!.iconUrl,
              );

          if (mounted) {
            showAppSnackBar(
              context,
              l10n.deleteWishSuccess,
              type: SnackBarType.success,
            );
          }
        } catch (e) {
          if (mounted) {
            showGenericError(context);
          }
        }
      },
      onCancel: () {},
    );
  }

  @override
  void dispose() {
    _nameInputController.dispose();
    _priceInputController.dispose();
    _quantityInputController.dispose();
    _linkInputController.dispose();
    _descriptionInputController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final wishlistThemeAsync = ref.watch(
      wishlistThemeProvider(
        widget.wishlistId,
      ),
    );
    final wishImageUrl = widget.isEditMode
        ? ref.watch(
            wishImageUrlProvider(
              (
                imagePath: widget.wish!.iconUrl,
                thumbnail: false,
              ),
            ),
          )
        : null;

    return wishlistThemeAsync.when(
      data: (wishlistTheme) {
        return Theme(
          data: wishlistTheme,
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: WishFormAppBar(
              title: widget.isEditMode
                  ? l10n.editWishBottomSheetTitle
                  : l10n.createWishBottomSheetTitle,
              backgroundColor: wishlistTheme.primaryColor,
              isFavourite: _isFavourite,
              onFavouriteTap: ({required isLiked}) async {
                setState(() {
                  _isFavourite = !isLiked;
                });
                return !isLiked;
              },
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20).copyWith(top: 0),
                      child: WishFormFields(
                        key: _wishFormFieldsKey,
                        formKey: _formKey,
                        nameController: _nameInputController,
                        priceController: _priceInputController,
                        quantityController: _quantityInputController,
                        linkController: _linkInputController,
                        descriptionController: _descriptionInputController,
                        onImageSelected: _onImageSelected,
                        existingImageUrl: wishImageUrl,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      spacing: 12,
                      children: [
                        if (widget.isEditMode)
                          SecondaryButton(
                            text: l10n.deleteWish,
                            onPressed: _isLoading ? null : _onDeleteWish,
                            style: BaseButtonStyle.large,
                            isStretched: true,
                          ),
                        PrimaryButton(
                          text: widget.isEditMode
                              ? l10n.editButton
                              : l10n.createButton,
                          onPressed: _isLoading ? null : _onSubmit,
                          style: BaseButtonStyle.large,
                          isStretched: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const Scaffold(
        backgroundColor: AppColors.background,
        body: SizedBox.shrink(),
      ),
    );
  }
}
