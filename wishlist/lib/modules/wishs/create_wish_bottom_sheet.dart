import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishs/wish_property.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/theme/utils/get_wishlist_theme.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/widgets/app_bottom_sheet.dart';

class _CreateWishBottomSheet extends StatefulWidget {
  const _CreateWishBottomSheet({
    required this.wishlist,
  });

  final Wishlist wishlist;

  @override
  State<_CreateWishBottomSheet> createState() => _CreateWishBottomSheetState();
}

class _CreateWishBottomSheetState extends State<_CreateWishBottomSheet> {
  final _scrollController = ScrollController();
  final _focusNodes = List.generate(5, (_) => FocusNode());
  final _nameInputController = TextEditingController();
  final _priceInputController = TextEditingController();
  final _quantityInputController = TextEditingController();
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
  void onCreateWish() {}

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
              child: Column(
                children: [
                  WishProperty(
                    icon: Icons.sell_outlined,
                    label: l10n.wishNameLabel,
                    inputController: _nameInputController,
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
