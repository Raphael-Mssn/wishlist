import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:like_button/like_button.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishs/view/widgets/wish_property.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/widgets/app_bottom_sheet.dart';
import 'package:wishlist/shared/widgets/static_title.dart';
import 'package:wishlist/shared/widgets/text_form_fields/validators/not_null_validator.dart';

class WishForm extends StatefulWidget {
  const WishForm({
    super.key,
    required this.title,
    required this.submitLabel,
    required this.nameInputController,
    required this.priceInputController,
    required this.quantityInputController,
    required this.linkInputController,
    required this.descriptionInputController,
    required this.formKey,
    required this.onSubmit,
    this.onSecondaryButtonTapped,
    this.secondaryButtonLabel,
    this.isFavourite = false,
    this.onFavouriteChanged,
  });

  final String title;
  final String submitLabel;
  final TextEditingController nameInputController;
  final TextEditingController priceInputController;
  final TextEditingController quantityInputController;
  final TextEditingController linkInputController;
  final TextEditingController descriptionInputController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;
  final VoidCallback? onSecondaryButtonTapped;
  final String? secondaryButtonLabel;
  final bool isFavourite;
  final void Function({required bool isFavourite})? onFavouriteChanged;

  @override
  State<WishForm> createState() => _WishFormState();
}

class _WishFormState extends State<WishForm> {
  final _focusNodes = List.generate(5, (_) => FocusNode());
  bool isKeyboardOpen = false;

  bool hasAnyFocus() {
    return _focusNodes.any((focusNode) => focusNode.hasFocus);
  }

  @override
  void initState() {
    super.initState();

    for (final focusNode in _focusNodes) {
      focusNode.addListener(() {
        if (focusNode.hasFocus) {
          setState(() {
            isKeyboardOpen = true;
          });
        }
        if (!hasAnyFocus()) {
          // Delay to wait for the keyboard to close
          Future.delayed(const Duration(milliseconds: 200), () {
            setState(() {
              isKeyboardOpen = false;
            });
          });
        }
      });
    }
  }

  void onSubmit() {
    if (!widget.formKey.currentState!.validate()) {
      // Focus name node
      _focusNodes[0].requestFocus();

      showAppSnackBar(
        context,
        context.l10n.wishNameError,
        type: SnackBarType.error,
      );

      return;
    }

    widget.onSubmit();
  }

  @override
  void dispose() {
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final onSecondaryButtonTapped = widget.onSecondaryButtonTapped;
    final secondaryButtonLabel = widget.secondaryButtonLabel;
    final hasSecondaryButton =
        onSecondaryButtonTapped != null && secondaryButtonLabel != null;

    const gapWishProperty = 12.0;
    const buttonSize = 32.0;

    return GestureDetector(
      onTap: () {
        for (final focusNode in _focusNodes) {
          focusNode.unfocus();
        }
      },
      child: AppBottomSheetWithThemeAndAppBarLayout(
        appBarTitle: StaticTitle(title: widget.title),
        theme: Theme.of(context),
        actionWidget: LikeButton(
          isLiked: widget.isFavourite,
          size: buttonSize,
          likeBuilder: (isLiked) {
            return isLiked
                ? const Icon(
                    Icons.favorite,
                    color: AppColors.favorite,
                    size: buttonSize,
                  )
                : const Icon(
                    Icons.favorite_border,
                    color: AppColors.background,
                    size: buttonSize,
                  );
          },
          onTap: (isLiked) async {
            widget.onFavouriteChanged?.call(isFavourite: !isLiked);
            return !isLiked;
          },
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: widget.formKey,
                  child: Column(
                    children: [
                      WishProperty(
                        icon: Icons.sell_outlined,
                        label: l10n.wishNameLabel,
                        inputController: widget.nameInputController,
                        validator: (value) => notNullValidator(value, l10n),
                        focusNode: _focusNodes[0],
                        nextFocusNode: _focusNodes[1],
                      ),
                      const Gap(gapWishProperty),
                      WishProperty(
                        icon: Icons.attach_money,
                        label: l10n.wishPriceLabel,
                        inputController: widget.priceInputController,
                        inputTextAlign: TextAlign.center,
                        focusNode: _focusNodes[1],
                        nextFocusNode: _focusNodes[2],
                        keyboardType: TextInputType.number,
                      ),
                      const Gap(gapWishProperty),
                      WishProperty(
                        icon: Icons.one_x_mobiledata,
                        label: l10n.wishQuantityLabel,
                        inputController: widget.quantityInputController,
                        inputTextAlign: TextAlign.center,
                        focusNode: _focusNodes[2],
                        nextFocusNode: _focusNodes[3],
                        keyboardType: TextInputType.number,
                      ),
                      const Gap(gapWishProperty),
                      WishProperty(
                        icon: Icons.link,
                        label: l10n.wishLinkLabel,
                        inputController: widget.linkInputController,
                        focusNode: _focusNodes[3],
                        nextFocusNode: _focusNodes[4],
                        keyboardType: TextInputType.url,
                      ),
                      const Gap(gapWishProperty),
                      WishProperty(
                        icon: Icons.description_outlined,
                        label: l10n.wishDescriptionLabel,
                        inputController: widget.descriptionInputController,
                        isInputBellow: true,
                        isMultilineInput: true,
                        focusNode: _focusNodes[4],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                if (hasSecondaryButton) ...[
                  AnimatedSwitcher(
                    duration: kThemeAnimationDuration,
                    child: isKeyboardOpen
                        ? const SizedBox.shrink()
                        : Builder(
                            // Needed to have the context with wishlist theme
                            builder: (context) {
                              return SecondaryButton(
                                text: secondaryButtonLabel,
                                onPressed: onSecondaryButtonTapped,
                                style: BaseButtonStyle.large,
                                isStretched: true,
                              );
                            },
                          ),
                  ),
                  const Gap(12),
                ],
                PrimaryButton(
                  text: widget.submitLabel,
                  onPressed: onSubmit,
                  style: BaseButtonStyle.large,
                  isStretched: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
