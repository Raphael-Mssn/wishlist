import 'package:flutter/material.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/widgets/password_strength_indicator.dart';
import 'package:wishlist/shared/widgets/text_form_fields/validators/password_validator.dart';

class InputPassword extends StatefulWidget {
  const InputPassword({
    super.key,
    required this.autofillHints,
    required this.controller,
    required this.label,
    required this.textInputAction,
    this.additionalValidator,
    this.showStrengthIndicator = false,
  });

  final String autofillHints;
  final TextEditingController controller;
  final String label;
  final TextInputAction textInputAction;
  final String? Function(String?)? additionalValidator;
  final bool showStrengthIndicator;

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
    final l10n = context.l10n;

    final textField = TextFormField(
      autofillHints: [widget.autofillHints],
      textInputAction: widget.textInputAction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.notNullError;
        }
        if (widget.showStrengthIndicator) {
          final securityError = passwordSecurityValidator(value, l10n);
          if (securityError != null) {
            return securityError;
          }
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
        errorMaxLines: 2,
      ),
      controller: widget.controller,
      obscureText: _obscureText,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        textField,
        AnimatedSwitcher(
          duration: kThemeAnimationDuration,
          switchInCurve: Curves.fastOutSlowIn,
          switchOutCurve: Curves.fastOutSlowIn,
          transitionBuilder: (child, animation) {
            return SizeTransition(
              sizeFactor: animation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: widget.showStrengthIndicator
              ? Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: PasswordStrengthIndicator(
                    controller: widget.controller,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
