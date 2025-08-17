import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:wishlist/gen/fonts.gen.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/infra/wish_taken_by_user_service.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/widgets/dialogs/app_dialog.dart';
import 'package:wishlist/shared/widgets/text_form_fields/validators/number_range_validator.dart';

const double _buttonSize = 48;
const double _buttonSpacing = 20;
const double _borderRadius = 8;
const double _borderWidth = 2;

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.isEnabled,
    required this.onTap,
    required this.onLongPress,
  });

  final IconData icon;
  final bool isEnabled;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: isEnabled ? onLongPress : null,
      child: FilledButton(
        onPressed: isEnabled ? onTap : null,
        style: FilledButton.styleFrom(
          backgroundColor:
              isEnabled ? Theme.of(context).primaryColor : AppColors.gainsboro,
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
          minimumSize: const Size(_buttonSize, _buttonSize),
        ),
        child: Icon(
          icon,
          color: isEnabled ? Colors.white : AppColors.makara,
          size: 24,
        ),
      ),
    );
  }
}

class _QuantitySelectionDialogContent extends StatefulWidget {
  const _QuantitySelectionDialogContent({
    required this.maxQuantity,
    required this.onQuantityChanged,
    required this.onValidationChanged,
  });

  final int maxQuantity;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<bool> onValidationChanged;

  @override
  State<_QuantitySelectionDialogContent> createState() =>
      _QuantitySelectionDialogContentState();
}

class _QuantitySelectionDialogContentState
    extends State<_QuantitySelectionDialogContent> {
  late TextEditingController _quantityController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: '1');
    _quantityController.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _quantityController.removeListener(_onControllerChanged);
    _quantityController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    final text = _quantityController.text;
    final quantity = int.tryParse(text);
    if (quantity != null) {
      widget.onQuantityChanged(quantity);
    }
    _validateForm();
    setState(() {});
  }

  void _updateQuantity(int quantity) {
    if (quantity >= 1 && quantity <= widget.maxQuantity) {
      _quantityController.text = quantity.toString();
    }
  }

  void _validateForm() {
    final valid = _formKey.currentState?.validate() ?? false;
    widget.onValidationChanged(valid);
  }

  String? _quantityValidator(String? value) {
    final l10n = context.l10n;
    return numberRangeValidator(value, 1, widget.maxQuantity, l10n);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: _validateForm,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bouton moins
              _QuantityButton(
                icon: Icons.remove,
                isEnabled: (int.tryParse(_quantityController.text) ?? 0) > 1,
                onTap: () {
                  final current = int.tryParse(_quantityController.text) ?? 1;
                  _updateQuantity(current - 1);
                },
                onLongPress: () => _updateQuantity(1),
              ),
              const Gap(_buttonSpacing),
              // Champ de saisie de quantité
              SizedBox(
                width: 80,
                child: TextFormField(
                  controller: _quantityController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: const TextStyle(
                    fontFamily: FontFamily.truculenta,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    errorStyle: const TextStyle(
                      color: Colors.transparent,
                      fontSize: 0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(_borderRadius),
                      borderSide: const BorderSide(
                        color: AppColors.makara,
                        width: _borderWidth,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(_borderRadius),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: _borderWidth,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(_borderRadius),
                      borderSide: const BorderSide(
                        color: AppColors.makara,
                        width: _borderWidth,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                  ),
                  validator: _quantityValidator,
                ),
              ),
              const Gap(_buttonSpacing),
              // Bouton plus
              _QuantityButton(
                icon: Icons.add,
                isEnabled: (() {
                  final quantityParsed = int.tryParse(_quantityController.text);
                  return quantityParsed == null ||
                      quantityParsed < widget.maxQuantity;
                })(),
                onTap: () {
                  final current = int.tryParse(_quantityController.text);
                  if (current == null) {
                    _updateQuantity(1);
                  } else {
                    _updateQuantity(current + 1);
                  }
                },
                onLongPress: () => _updateQuantity(widget.maxQuantity),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> showQuantitySelectionDialog(
  BuildContext context,
  WidgetRef ref, {
  required Wish wish,
}) async {
  final l10n = context.l10n;
  var selectedQuantity = 1;

  // Utilisation d'une ValueNotifier pour gérer l'état de validation
  final isValidNotifier = ValueNotifier<bool>(true);

  return showAppDialog(
    context,
    title: l10n.selectQuantityToGive,
    content: _QuantitySelectionDialogContent(
      maxQuantity: wish.availableQuantity,
      onQuantityChanged: (quantity) {
        selectedQuantity = quantity;
      },
      onValidationChanged: (valid) {
        isValidNotifier.value = valid;
      },
    ),
    confirmButtonLabel: l10n.confirmDialogConfirmButtonLabel,
    isConfirmEnabled: isValidNotifier,
    onCancel: () {},
    onConfirm: () async {
      await ref.read(wishTakenByUserServiceProvider).wishTakenByUser(
            wish,
            quantity: selectedQuantity,
          );
      if (context.mounted) {
        context.pop();
      }
    },
  );
}
