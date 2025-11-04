import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishs/view/widgets/wish_form.dart';
import 'package:wishlist/shared/infra/wish_mutations_provider.dart';
import 'package:wishlist/shared/models/wish/create_request/wish_create_request.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/widgets/app_bottom_sheet.dart';

class _CreateWishBottomSheet extends ConsumerStatefulWidget {
  const _CreateWishBottomSheet({
    required this.wishlist,
  });

  final Wishlist wishlist;

  @override
  ConsumerState<_CreateWishBottomSheet> createState() =>
      _CreateWishBottomSheetState();
}

class _CreateWishBottomSheetState
    extends ConsumerState<_CreateWishBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameInputController = TextEditingController();
  final _priceInputController = TextEditingController();
  final _quantityInputController = TextEditingController(text: '1');
  final _linkInputController = TextEditingController();
  final _descriptionInputController = TextEditingController();

  bool _isFavourite = false;

  Future<void> onCreateWish() async {
    final name = _nameInputController.text;
    final price = _priceInputController.text;
    final quantity = _quantityInputController.text;
    final link = _linkInputController.text;
    final description = _descriptionInputController.text;

    final wish = WishCreateRequest(
      name: name,
      price: double.tryParse(price),
      quantity: int.tryParse(quantity),
      description: description,
      wishlistId: widget.wishlist.id,
      updatedBy: widget.wishlist.idOwner,
      linkUrl: link,
      isFavourite: _isFavourite,
    );

    try {
      await ref.read(createWishMutationProvider.notifier).createWish(wish);

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
      title: l10n.createWishBottomSheetTitle,
      submitLabel: l10n.createButton,
      nameInputController: _nameInputController,
      priceInputController: _priceInputController,
      quantityInputController: _quantityInputController,
      linkInputController: _linkInputController,
      descriptionInputController: _descriptionInputController,
      onSubmit: onCreateWish,
      isFavourite: _isFavourite,
      onFavouriteChanged: ({required isFavourite}) {
        setState(() {
          _isFavourite = isFavourite;
        });
      },
    );
  }
}

Future<void> showCreateWishBottomSheet(
  BuildContext context,
  Wishlist wishlist,
) async {
  await showAppBottomSheet(
    context,
    body: _CreateWishBottomSheet(
      wishlist: wishlist,
    ),
  );
}
