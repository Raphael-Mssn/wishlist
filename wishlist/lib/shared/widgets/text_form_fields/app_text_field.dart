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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.gainsboro,
        borderRadius: BorderRadius.circular(16),
        border: _hasError ? Border.all(color: Colors.red, width: 2) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          crossAxisAlignment: widget.maxLines != null && widget.maxLines! > 1
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: widget.maxLines != null && widget.maxLines! > 1 ? 12 : 0,
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
                  alignLabelWithHint:
                      widget.maxLines != null && widget.maxLines! > 1,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  errorStyle: const TextStyle(fontSize: 0),
                  contentPadding: EdgeInsets.only(
                    top: 12,
                    bottom: 12,
                    right: widget.suffixButtons != null &&
                            widget.suffixButtons!.isNotEmpty
                        ? 8
                        : 0,
                  ),
                ),
              ),
            ),
            if (widget.suffixButtons != null &&
                widget.suffixButtons!.isNotEmpty) ...[
              ...widget.suffixButtons!,
            ],
          ],
        ),
      ),
    );
  }
}
