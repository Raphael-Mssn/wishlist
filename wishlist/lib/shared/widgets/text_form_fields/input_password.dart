import 'package:flutter/material.dart';
import 'package:wishlist/l10n/l10n.dart';

class InputPassword extends StatelessWidget {
  const InputPassword({
    super.key,
    required this.autofillHints,
    required this.controller,
    required this.label,
    required this.textInputAction,
    this.additionalValidator,
  });

  final String autofillHints;
  final TextEditingController controller;
  final String label;
  final TextInputAction textInputAction;
  final String? Function(String?)? additionalValidator;

  @override
  Widget build(BuildContext context) {
    final additionalValidator = this.additionalValidator;

    return TextFormField(
      autofillHints: [autofillHints],
      textInputAction: textInputAction,
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 6) {
          return context.l10n.passwordLengthError;
        }
        if (additionalValidator != null) {
          return additionalValidator(value);
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        label: Text(label),
      ),
      controller: controller,
      obscureText: true,
    );
  }
}
