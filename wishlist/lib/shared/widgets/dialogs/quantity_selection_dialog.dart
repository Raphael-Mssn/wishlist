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
  late int _selectedQuantity;
  late TextEditingController _quantityController;
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    _selectedQuantity = 1;
    _quantityController = TextEditingController(text: '1');
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _updateQuantity(int quantity) {
    if (quantity >= 1 && quantity <= widget.maxQuantity) {
      setState(() {
        _selectedQuantity = quantity;
        _quantityController.text = quantity.toString();
        _isValid = true;
      });
      widget.onQuantityChanged(quantity);
      widget.onValidationChanged(true);
    }
  }

  void _onTextChanged(String value) {
    final quantity = int.tryParse(value);
    if (quantity != null && quantity >= 1 && quantity <= widget.maxQuantity) {
      setState(() {
        _selectedQuantity = quantity;
        _isValid = true;
      });
      widget.onQuantityChanged(quantity);
      widget.onValidationChanged(true);
    } else {
      setState(() {
        _isValid = false;
      });
      widget.onValidationChanged(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bouton moins
            Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: _selectedQuantity > 1
                    ? () => _updateQuantity(_selectedQuantity - 1)
                    : null,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedQuantity > 1
                        ? Theme.of(context).primaryColor
                        : AppColors.gainsboro,
                  ),
                  child: Icon(
                    Icons.remove,
                    color:
                        _selectedQuantity > 1 ? Colors.white : AppColors.makara,
                    size: 20,
                  ),
                ),
              ),
            ),
            const Gap(20),
            // Champ de saisie de quantité
            SizedBox(
              width: 80,
              child: TextField(
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _isValid ? AppColors.makara : Colors.red,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _isValid
                          ? Theme.of(context).primaryColor
                          : Colors.red,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _isValid ? AppColors.makara : Colors.red,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                ),
                onChanged: _onTextChanged,
              ),
            ),
            const Gap(20),
            // Bouton plus
            Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: _selectedQuantity < widget.maxQuantity
                    ? () => _updateQuantity(_selectedQuantity + 1)
                    : null,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedQuantity < widget.maxQuantity
                        ? Theme.of(context).primaryColor
                        : AppColors.gainsboro,
                  ),
                  child: Icon(
                    Icons.add,
                    color: _selectedQuantity < widget.maxQuantity
                        ? Colors.white
                        : AppColors.makara,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
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
