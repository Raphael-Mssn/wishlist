import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:wishlist/l10n/l10n.dart';

class InputEmail extends StatelessWidget {
  const InputEmail({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            !EmailValidator.validate(controller.text)) {
          return l10n.validEmailError;
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email),
        label: Text(l10n.emailField),
      ),
      controller: controller,
    );
  }
}
