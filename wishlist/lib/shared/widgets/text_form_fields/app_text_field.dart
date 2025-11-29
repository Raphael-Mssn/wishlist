import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

/// Un TextField avec un design arrondi et un icône
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.maxLines,
    this.minLines,
    this.suffixButtons,
    this.inputFormatters,
    this.textCapitalization,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final List<Widget>? suffixButtons;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization? textCapitalization;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _hasError = false;
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errorBorder =
        _hasError ? Border.all(color: Colors.red, width: 2) : null;
    final suffixButtons = widget.suffixButtons ?? const <Widget>[];
    final hasSuffixButtons = suffixButtons.isNotEmpty;
    final contentPadding = const EdgeInsets.symmetric(vertical: 12)
        .copyWith(right: hasSuffixButtons ? 8 : 0);
    final isMultiline = (widget.maxLines ?? 1) > 1;
    final textCapitalization =
        widget.textCapitalization ?? TextCapitalization.none;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.gainsboro,
        borderRadius: BorderRadius.circular(16),
        border: errorBorder,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          crossAxisAlignment: isMultiline
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: isMultiline ? 12 : 0,
              ),
              child: Icon(
                widget.icon,
                color: AppColors.makara,
                size: 24,
              ),
            ),
            const Gap(12),
            Expanded(
              child: TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                cursorErrorColor: Colors.red,
                textCapitalization: textCapitalization,
                validator: (value) {
                  final error = widget.validator?.call(value);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _hasError = error != null;
                      });
                      // Remettre le focus sur le champ en erreur
                      if (error != null) {
                        _focusNode.requestFocus();
                      }
                    }
                  });
                  return error;
                },
                keyboardType: widget.keyboardType,
                inputFormatters: widget.inputFormatters,
                maxLines: widget.maxLines ?? 1,
                minLines: widget.minLines ?? 1,
                style: AppTextStyles.small.copyWith(
                  color: AppColors.darkGrey,
                ),
                decoration: InputDecoration(
                  labelText: widget.label,
                  labelStyle: AppTextStyles.small.copyWith(
                    color: AppColors.makara,
                  ),
                  alignLabelWithHint: isMultiline,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  errorStyle: const TextStyle(fontSize: 0),
                  contentPadding: contentPadding,
                ),
              ),
            ),
            if (hasSuffixButtons) ...suffixButtons,
          ],
        ),
      ),
    );
  }
}
