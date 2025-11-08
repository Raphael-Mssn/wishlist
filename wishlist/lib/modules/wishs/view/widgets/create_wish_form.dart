import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishs/view/widgets/image_upload_field.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/widgets/text_form_fields/app_text_field.dart';
import 'package:wishlist/shared/widgets/text_form_fields/formatters/decimal_text_input_formatter.dart';
import 'package:wishlist/shared/widgets/text_form_fields/validators/not_null_validator.dart';

const _smallGap = Gap(8);
const _mediumGap = Gap(16);

/// Formulaire de création de wish
class CreateWishForm extends StatelessWidget {
  const CreateWishForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.priceController,
    required this.quantityController,
    required this.linkController,
    required this.descriptionController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController quantityController;
  final TextEditingController linkController;
  final TextEditingController descriptionController;

  Future<void> _pasteLink(BuildContext context) async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text != null) {
      linkController.text = clipboardData!.text!;
    }
  }

  Future<void> _openLink(BuildContext context) async {
    final link = linkController.text.trim();
    if (link.isEmpty) {
      if (context.mounted) {
        showAppSnackBar(
          context,
          context.l10n.linkNotValid,
          type: SnackBarType.error,
        );
      }
      return;
    }

    try {
      final uri = Uri.parse(link);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(
          context,
          context.l10n.linkNotValid,
          type: SnackBarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _smallGap,
          AppTextField(
            controller: nameController,
            label: l10n.wishNameLabel,
            icon: Icons.sell_outlined,
            validator: (value) => notNullValidator(value, l10n),
          ),
          _mediumGap,
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: priceController,
                  label: l10n.wishPriceLabel,
                  icon: Icons.attach_money,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    DecimalTextInputFormatter(),
                  ],
                ),
              ),
              const Gap(12),
              Expanded(
                child: AppTextField(
                  controller: quantityController,
                  label: l10n.wishQuantityLabel,
                  icon: Icons.one_x_mobiledata,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          _mediumGap,
          AppTextField(
            controller: linkController,
            label: l10n.wishLinkLabel,
            icon: Icons.link,
            keyboardType: TextInputType.url,
            suffixButtons: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.content_paste,
                    size: 20,
                  ),
                  onPressed: () => _pasteLink(context),
                  tooltip: 'Coller',
                  color: AppColors.makara,
                ),
              ),
              _smallGap,
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.open_in_new,
                    size: 20,
                  ),
                  onPressed: () => _openLink(context),
                  tooltip: 'Ouvrir',
                  color: AppColors.makara,
                ),
              ),
            ],
          ),
          _mediumGap,
          AppTextField(
            controller: descriptionController,
            label: l10n.wishDescriptionLabel,
            icon: Icons.description_outlined,
            maxLines: 4,
            minLines: 4,
          ),
          _mediumGap,
          ImageUploadField(
            onTap: () {
              // TODO: Implémenter l'upload d'image
            },
          ),
        ],
      ),
    );
  }
}
