import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishs/wish_property.dart';
import 'package:wishlist/shared/infra/utils/scaffold_messenger_extension.dart';
import 'package:wishlist/shared/infra/wishs_from_wishlist_provider.dart';
import 'package:wishlist/shared/models/wish/create_request/wish_create_request.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/theme/utils/get_wishlist_theme.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/widgets/app_bottom_sheet.dart';
import 'package:wishlist/shared/widgets/text_form_fields/validators/not_null_validator.dart';

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

  final _scrollController = ScrollController();
  final _focusNodes = List.generate(5, (_) => FocusNode());

  final _nameInputController = TextEditingController();
  final _priceInputController = TextEditingController();
  final _quantityInputController = TextEditingController(text: '1');
  final _linkInputController = TextEditingController();
  final _descriptionInputController = TextEditingController();

  @override
  void initState() {
    super.initState();

    for (final focusNode in _focusNodes) {
      focusNode.addListener(() {
        if (focusNode.hasFocus) {
          _scrollToFocusedField(focusNode);
        }
      });
    }
  }

  void _scrollToFocusedField(FocusNode focusNode) {
    final context = focusNode.context;
    if (context != null && _scrollController.hasClients) {
      Scrollable.ensureVisible(
        alignment: 0.2,
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onFavorite() {}

  Future<void> onCreateWish() async {
    final name = _nameInputController.text;
    final price = _priceInputController.text;
    final quantity = _quantityInputController.text;
    final link = _linkInputController.text;
    final description = _descriptionInputController.text;

    if (!_formKey.currentState!.validate()) {
      // Focus name node
      _focusNodes[0].requestFocus();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.wishNameError,
          ),
        ),
      );

      return;
    }

    final wish = WishCreateRequest(
      name: name,
      price: double.tryParse(price),
      quantity: int.parse(quantity),
      description: description,
      wishlistId: widget.wishlist.id,
      updatedBy: widget.wishlist.idOwner,
      linkUrl: link,
    );

    try {
      await ref
          .read(wishsFromWishlistProvider(widget.wishlist.id).notifier)
          .createWish(
            wish,
          );

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showGenericError(context);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }

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
    final wishlist = widget.wishlist;
    final wishlistTheme = getWishlistTheme(context, wishlist);

    return AppBottomSheetWithThemeAndAppBarLayout(
      theme: wishlistTheme,
      title: l10n.createWishBottomSheetTitle,
      actionIcon: const Icon(Icons.favorite_border),
      onActionTapped: onFavorite,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    WishProperty(
                      icon: Icons.sell_outlined,
                      label: l10n.wishNameLabel,
                      inputController: _nameInputController,
                      validator: (value) => notNullValidator(value, l10n),
                      focusNode: _focusNodes[0],
                    ),
                    const Gap(16),
                    WishProperty(
                      icon: Icons.attach_money,
                      label: l10n.wishPriceLabel,
                      inputController: _priceInputController,
                      inputTextAlign: TextAlign.center,
                      focusNode: _focusNodes[1],
                    ),
                    const Gap(16),
                    WishProperty(
                      icon: Icons.one_x_mobiledata,
                      label: l10n.wishQuantityLabel,
                      inputController: _quantityInputController,
                      inputTextAlign: TextAlign.center,
                      focusNode: _focusNodes[2],
                    ),
                    const Gap(16),
                    WishProperty(
                      icon: Icons.link,
                      label: l10n.wishLinkLabel,
                      inputController: _linkInputController,
                      focusNode: _focusNodes[3],
                    ),
                    const Gap(16),
                    WishProperty(
                      icon: Icons.description_outlined,
                      label: l10n.wishDescriptionLabel,
                      inputController: _descriptionInputController,
                      isInputBellow: true,
                      isMultilineInput: true,
                      focusNode: _focusNodes[4],
                    ),
                    const Gap(16),
                  ],
                ),
              ),
            ),
          ),
          PrimaryButton(
            text: l10n.createButton,
            onPressed: onCreateWish,
            style: BaseButtonStyle.large,
            isStretched: true,
          ),
        ],
      ),
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
