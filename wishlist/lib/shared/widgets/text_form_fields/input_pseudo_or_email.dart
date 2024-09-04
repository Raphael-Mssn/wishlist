import 'package:flutter/material.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/widgets/text_form_fields/validators/pseudo_validator.dart';

class InputPseudoOrEmail extends StatelessWidget {
  const InputPseudoOrEmail({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return TextFormField(
      autofillHints: const [AutofillHints.email],
      textInputAction: TextInputAction.next,
      validator: (value) => pseudoValidator(value, l10n),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        label: Text(l10n.emailOrPseudoHint),
      ),
      controller: controller,
    );
  }
}
