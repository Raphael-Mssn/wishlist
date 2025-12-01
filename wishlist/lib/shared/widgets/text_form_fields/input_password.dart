import 'package:flutter/material.dart';
import 'package:wishlist/l10n/l10n.dart';

class InputPassword extends StatefulWidget {
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
  State<InputPassword> createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  bool _obscureText = true;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final additionalValidator = widget.additionalValidator;

    return TextFormField(
      autofillHints: [widget.autofillHints],
      textInputAction: widget.textInputAction,
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
        label: Text(widget.label),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: _toggleObscureText,
        ),
      ),
      controller: widget.controller,
      obscureText: _obscureText,
    );
  }
}
