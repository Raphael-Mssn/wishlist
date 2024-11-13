import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishs/view/widgets/wish_property.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/utils/double_extension.dart';
import 'package:wishlist/shared/widgets/app_bottom_sheet.dart';

class _ConsultWishBottomSheet extends StatelessWidget {
  const _ConsultWishBottomSheet({
    required this.wish,
  });

  final Wish wish;

  void onOpenLink() {}

  void onGiveIt() {}

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final linkUrl = wish.linkUrl;

    final priceInputController = TextEditingController(
      text: wish.price.toStringWithout0OrEmpty(),
    );
    final quantityInputController = TextEditingController(
      text: wish.quantity.toString(),
    );
    final descriptionInputController =
        TextEditingController(text: wish.description);

    const gapWishProperty = 12.0;

    return AppBottomSheetWithThemeAndAppBarLayout(
      title: wish.name,
      theme: Theme.of(context),
      actionIcon: Icons.favorite_border,
      onActionTapped: () {},
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  WishProperty(
                    icon: Icons.attach_money,
                    label: l10n.wishPriceLabel,
                    inputController: priceInputController,
                    inputTextAlign: TextAlign.center,
                    readOnly: true,
                  ),
                  const Gap(gapWishProperty),
                  WishProperty(
                    icon: Icons.one_x_mobiledata,
                    label: l10n.wishQuantityLabel,
                    inputController: quantityInputController,
                    inputTextAlign: TextAlign.center,
                    readOnly: true,
                  ),
                  const Gap(gapWishProperty),
                  WishProperty(
                    icon: Icons.description_outlined,
                    label: l10n.wishDescriptionLabel,
                    inputController: descriptionInputController,
                    isInputBellow: true,
                    isMultilineInput: true,
                    readOnly: true,
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              if (linkUrl != null && linkUrl.isNotEmpty)
                SecondaryButton(
                  text: l10n.openLink,
                  style: BaseButtonStyle.large,
                  isStretched: true,
                  onPressed: onOpenLink,
                ),
              const Gap(12),
              PrimaryButton(
                text: l10n.iWantToGiveIt,
                style: BaseButtonStyle.large,
                isStretched: true,
                onPressed: onGiveIt,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> showConsultWishBottomSheet(
  BuildContext context,
  Wish wish,
) async {
  await showAppBottomSheet(
    context,
    body: _ConsultWishBottomSheet(
      wish: wish,
    ),
  );
}
