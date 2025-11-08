import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

/// Un TextField avec un design arrondi et un icône
class AppTextField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.gainsboro,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          crossAxisAlignment: maxLines != null && maxLines! > 1
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: maxLines != null && maxLines! > 1 ? 12 : 0,
              ),
              child: Icon(
                icon,
                color: AppColors.makara,
                size: 24,
              ),
            ),
            const Gap(12),
            Expanded(
              child: TextFormField(
                controller: controller,
                validator: validator,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                maxLines: maxLines ?? 1,
                minLines: minLines ?? 1,
                style: AppTextStyles.small.copyWith(
                  color: AppColors.darkGrey,
                ),
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: AppTextStyles.small.copyWith(
                    color: AppColors.makara,
                  ),
                  alignLabelWithHint: maxLines != null && maxLines! > 1,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(
                    top: 12,
                    bottom: 12,
                    right: suffixButtons != null && suffixButtons!.isNotEmpty
                        ? 8
                        : 0,
                  ),
                ),
              ),
            ),
            if (suffixButtons != null && suffixButtons!.isNotEmpty) ...[
              ...suffixButtons!,
            ],
          ],
        ),
      ),
    );
  }
}
