import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

class WishProperty extends StatelessWidget {
  const WishProperty({
    super.key,
    required this.icon,
    required this.label,
    required this.inputController,
    required this.focusNode,
    required this.nextFocusNode,
    this.validator,
    this.inputTextAlign = TextAlign.start,
    this.isInputBellow = false,
    this.isMultilineInput = false,
  });

  final IconData icon;
  final String label;
  final TextEditingController inputController;
  final String? Function(String?)? validator;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final TextAlign inputTextAlign;
  final bool isInputBellow;
  final bool isMultilineInput;

  @override
  Widget build(BuildContext context) {
    const borderStyle = OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: AppColors.pastelGray,
      ),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    );
    final errorBorderStyle = borderStyle.copyWith(
      borderSide: borderStyle.borderSide.copyWith(
        // TODO: Use error color from theme
        color: Colors.red,
      ),
    );

    final input = TextFormField(
      textAlign: inputTextAlign,
      controller: inputController,
      focusNode: focusNode,
      onFieldSubmitted: (_) {
        if (nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        }
      },
      validator: validator,
      cursorErrorColor: Colors.red,
      decoration: InputDecoration(
        enabledBorder: borderStyle,
        focusedBorder: borderStyle,
        disabledBorder: borderStyle,
        errorBorder: errorBorderStyle,
        focusedErrorBorder: errorBorderStyle,
        // Hide error text
        errorStyle: const TextStyle(
          fontSize: 0,
        ),
      ),
      maxLines: isMultilineInput ? null : 1,
      textInputAction:
          isMultilineInput ? TextInputAction.unspecified : TextInputAction.next,
      keyboardType:
          isMultilineInput ? TextInputType.multiline : TextInputType.text,
    );

    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 4,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.gainsboro,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 28,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    label,
                    style: AppTextStyles.small.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.makara,
                    ),
                  ),
                ],
              ),
            ),
            if (!isInputBellow) ...[
              const Gap(32),
              Flexible(
                flex: 5,
                child: input,
              ),
            ],
          ],
        ),
        if (isInputBellow) ...[
          const Gap(8),
          input,
        ],
      ],
    );
  }
}
