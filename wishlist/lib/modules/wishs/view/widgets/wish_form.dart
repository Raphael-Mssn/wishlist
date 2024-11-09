import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishs/view/widgets/wish_property.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/widgets/app_bottom_sheet.dart';
import 'package:wishlist/shared/widgets/text_form_fields/validators/not_null_validator.dart';

class WishForm extends StatefulWidget {
  const WishForm({
    super.key,
    required this.title,
    required this.submitLabel,
    required this.theme,
    required this.nameInputController,
    required this.priceInputController,
    required this.quantityInputController,
    required this.linkInputController,
    required this.descriptionInputController,
    required this.formKey,
    required this.onSubmit,
  });

  final String title;
  final String submitLabel;
  final ThemeData theme;
  final TextEditingController nameInputController;
  final TextEditingController priceInputController;
  final TextEditingController quantityInputController;
  final TextEditingController linkInputController;
  final TextEditingController descriptionInputController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;

  @override
  State<WishForm> createState() => _WishFormState();
}

class _WishFormState extends State<WishForm> {
  final _scrollController = ScrollController();
  final _focusNodes = List.generate(5, (_) => FocusNode());

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

  void onSubmit() {
    if (!widget.formKey.currentState!.validate()) {
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

    widget.onSubmit();
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

  @override
  void dispose() {
    _scrollController.dispose();
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppBottomSheetWithThemeAndAppBarLayout(
      title: widget.title,
      theme: widget.theme,
      actionIcon: const Icon(Icons.favorite_border),
      onActionTapped: () {},
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
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
                    ),
                    const Gap(16),
                    WishProperty(
                      icon: Icons.attach_money,
                      label: l10n.wishPriceLabel,
                      inputController: widget.priceInputController,
                      inputTextAlign: TextAlign.center,
                      focusNode: _focusNodes[1],
                    ),
                    const Gap(16),
                    WishProperty(
                      icon: Icons.one_x_mobiledata,
                      label: l10n.wishQuantityLabel,
                      inputController: widget.quantityInputController,
                      inputTextAlign: TextAlign.center,
                      focusNode: _focusNodes[2],
                    ),
                    const Gap(16),
                    WishProperty(
                      icon: Icons.link,
                      label: l10n.wishLinkLabel,
                      inputController: widget.linkInputController,
                      focusNode: _focusNodes[3],
                    ),
                    const Gap(16),
                    WishProperty(
                      icon: Icons.description_outlined,
                      label: l10n.wishDescriptionLabel,
                      inputController: widget.descriptionInputController,
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
            text: widget.submitLabel,
            onPressed: onSubmit,
            style: BaseButtonStyle.large,
            isStretched: true,
          ),
        ],
      ),
    );
  }
}
