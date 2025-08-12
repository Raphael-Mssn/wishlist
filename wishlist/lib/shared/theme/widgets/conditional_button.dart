import 'package:flutter/material.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';

class ConditionalButton extends StatelessWidget {
  const ConditionalButton({
    required this.text,
    required this.onPressed,
    required this.style,
    required this.isEnabled,
    super.key,
  });

  final String text;
  final void Function() onPressed;
  final BaseButtonStyle style;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isEnabled ? Theme.of(context).primaryColor : AppColors.gainsboro,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isEnabled ? onPressed : null,
          child: Padding(
            padding: style.padding,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              style: style.textStyle.copyWith(
                color: isEnabled
                    ? Theme.of(context).scaffoldBackgroundColor
                    : AppColors.makara,
                fontWeight: FontWeight.bold,
              ),
              child: Text(
                text,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
