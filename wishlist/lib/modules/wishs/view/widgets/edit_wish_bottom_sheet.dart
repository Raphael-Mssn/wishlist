import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishs/view/widgets/wish_form.dart';
import 'package:wishlist/shared/infra/wishs_from_wishlist_provider.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/utils/double_extension.dart';
import 'package:wishlist/shared/utils/scaffold_messenger_extension.dart';
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
  }

  Future<void> onEditWish() async {
    final name = _nameInputController.text;
    final price = double.tryParse(_priceInputController.text);
    final quantity = int.tryParse(_quantityInputController.text);
    final link = _linkInputController.text;
    final description = _descriptionInputController.text;

    final wish = widget.wish;

    final wishToUpdate = wish.copyWith(
      name: name,
      price: price,
      quantity: quantity,
      description: description,
      linkUrl: link,
    );

    try {
      await ref
          .read(wishsFromWishlistProvider(wish.wishlistId).notifier)
          .updateWish(
            wishToUpdate,
          );

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.updateSuccess),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showGenericError();
      }
    }
  }

  void onDeleteWish() {
    final l10n = context.l10n;

    showAppDialog(
      context,
      title: l10n.deleteWish,
      content: const SizedBox.shrink(),
      confirmButtonLabel: l10n.confirmDialogConfirmButtonLabel,
      onConfirm: () async {
        try {
          await ref
              .read(wishsFromWishlistProvider(widget.wish.wishlistId).notifier)
              .deleteWish(
                widget.wish.id,
              );
          if (mounted) {
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.deleteWishlistSuccess),
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showGenericError();
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
