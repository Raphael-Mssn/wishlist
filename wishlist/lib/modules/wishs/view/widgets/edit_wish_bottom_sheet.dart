import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishs/view/widgets/wish_form.dart';
import 'package:wishlist/shared/infra/wishs_from_wishlist_provider.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/utils/double_extension.dart';
import 'package:wishlist/shared/widgets/app_bottom_sheet.dart';
import 'package:wishlist/shared/widgets/dialogs/app_dialog.dart';

class _EditWishBottomSheet extends ConsumerStatefulWidget {
  const _EditWishBottomSheet({
    required this.wish,
  });

  final Wish wish;

  @override
  ConsumerState<_EditWishBottomSheet> createState() =>
      _EditWishBottomSheetState();
}

class _EditWishBottomSheetState extends ConsumerState<_EditWishBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameInputController;
  late TextEditingController _priceInputController;
  late TextEditingController _quantityInputController;
  late TextEditingController _linkInputController;
  late TextEditingController _descriptionInputController;

  late bool _isFavourite;

  @override
  void initState() {
    super.initState();

    final wish = widget.wish;
    final price = wish.price;

    _nameInputController = TextEditingController(text: wish.name);
    _priceInputController = TextEditingController(
      text: price.toStringWithout0OrEmpty(),
    );
    _quantityInputController =
        TextEditingController(text: wish.quantity.toString());
    _linkInputController = TextEditingController(text: wish.linkUrl);
    _descriptionInputController = TextEditingController(text: wish.description);

    _isFavourite = wish.isFavourite;
  }

  bool _validateQuantity(int? quantity) {
    if (quantity == null) {
      return true;
    }

    // La quantité ne peut pas être inférieure à la quantité déjà réservée
    if (quantity < widget.wish.totalBookedQuantity) {
      showAppSnackBar(
        context,
        context.l10n.quantityCannotBeLowerThanBooked(
          widget.wish.totalBookedQuantity,
        ),
        type: SnackBarType.error,
      );
      return false;
    }

    return true;
  }

  Future<void> onEditWish() async {
    final name = _nameInputController.text;
    final price = double.tryParse(_priceInputController.text);
    final quantity = int.tryParse(_quantityInputController.text);
    final link = _linkInputController.text;
    final description = _descriptionInputController.text;

    if (!_validateQuantity(quantity)) {
      return;
    }

    final wish = widget.wish;

    final wishToUpdate = wish.copyWith(
      name: name,
      price: price,
      quantity: quantity,
      description: description,
      linkUrl: link,
      isFavourite: _isFavourite,
    );

    try {
      await ref
          .read(wishsFromWishlistProvider(wish.wishlistId).notifier)
          .updateWish(
            wishToUpdate,
          );

      ref.invalidate(wishsFromWishlistProvider(wish.wishlistId));

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

  void onDeleteWish() {
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
          await ref
              .read(wishsFromWishlistProvider(widget.wish.wishlistId).notifier)
              .deleteWish(
                widget.wish.id,
              );
          if (mounted) {
            showAppSnackBar(
              context,
              l10n.deleteWishSuccess,
              type: SnackBarType.success,
            );
            context.pop();
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

    return WishForm(
      formKey: _formKey,
      title: l10n.editWishBottomSheetTitle,
      submitLabel: l10n.editButton,
      nameInputController: _nameInputController,
      priceInputController: _priceInputController,
      quantityInputController: _quantityInputController,
      linkInputController: _linkInputController,
      descriptionInputController: _descriptionInputController,
      onSubmit: onEditWish,
      onSecondaryButtonTapped: onDeleteWish,
      secondaryButtonLabel: l10n.deleteWish,
      isFavourite: _isFavourite,
      onFavouriteChanged: ({required isFavourite}) {
        setState(() {
          _isFavourite = isFavourite;
        });
      },
    );
  }
}

Future<void> showEditWishBottomSheet(
  BuildContext context,
  Wish wish,
) async {
  await showAppBottomSheet(
    context,
    body: _EditWishBottomSheet(
      wish: wish,
    ),
  );
}
