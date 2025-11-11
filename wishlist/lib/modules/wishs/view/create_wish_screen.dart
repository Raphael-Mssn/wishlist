import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishs/view/widgets/create_wish_app_bar.dart';
import 'package:wishlist/modules/wishs/view/widgets/create_wish_form.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_streams_providers.dart';
import 'package:wishlist/shared/infra/wish_mutations_provider.dart';
import 'package:wishlist/shared/models/wish/create_request/wish_create_request.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/providers/wishlist_theme_provider.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';

class CreateWishScreen extends ConsumerStatefulWidget {
  const CreateWishScreen({
    super.key,
    required this.wishlistId,
  });

  final int wishlistId;

  @override
  ConsumerState<CreateWishScreen> createState() => _CreateWishScreenState();
}

class _CreateWishScreenState extends ConsumerState<CreateWishScreen> {
  final _formKey = GlobalKey<FormState>();
  final _createWishFormKey = GlobalKey<CreateWishFormState>();

  final _nameInputController = TextEditingController();
  final _priceInputController = TextEditingController();
  final _quantityInputController = TextEditingController(text: '1');
  final _linkInputController = TextEditingController();
  final _descriptionInputController = TextEditingController();

  bool _isFavourite = false;
  bool _isLoading = false;
  File? _selectedImage;

  void _onImageSelected(File? imageFile) {
    setState(() {
      _selectedImage = imageFile;
    });
  }

  Future<void> _onCreateWish() async {
    // Activer la validation automatique après la première tentative
    _createWishFormKey.currentState?.enableAutovalidation();

    if (!_formKey.currentState!.validate()) {
      showAppSnackBar(
        context,
        context.l10n.wishNameError,
        type: SnackBarType.error,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final wishlistAsync =
        ref.read(watchWishlistByIdProvider(widget.wishlistId));

    wishlistAsync.whenData((wishlist) async {
      final name = _nameInputController.text;
      final price = _priceInputController.text.replaceAll(',', '.');
      final quantity = _quantityInputController.text;
      final link = _linkInputController.text;
      final description = _descriptionInputController.text;

      final wish = WishCreateRequest(
        name: name,
        price: double.tryParse(price),
        quantity: int.tryParse(quantity),
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
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
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
    final wishlistTheme = ref.watch(
      wishlistThemeProvider(
        widget.wishlistId,
      ),
    );

    return Theme(
      data: wishlistTheme,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CreateWishAppBar(
          title: l10n.createWishBottomSheetTitle,
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
                  child: CreateWishForm(
                    key: _createWishFormKey,
                    formKey: _formKey,
                    nameController: _nameInputController,
                    priceController: _priceInputController,
                    quantityController: _quantityInputController,
                    linkController: _linkInputController,
                    descriptionController: _descriptionInputController,
                    onImageSelected: _onImageSelected,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: PrimaryButton(
                  text: l10n.createButton,
                  onPressed: _isLoading ? null : _onCreateWish,
                  style: BaseButtonStyle.large,
                  isStretched: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
