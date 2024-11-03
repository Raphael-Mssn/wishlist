import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

class WishlistToggleSwitch extends StatelessWidget {
  const WishlistToggleSwitch({
    super.key,
    required this.current,
    required this.onChanged,
    required this.trueLabel,
    required this.falseLabel,
    required this.trueIcon,
    required this.falseIcon,
  });

  final bool current;
  final ValueChanged<bool> onChanged;
  final String trueLabel;
  final String falseLabel;
  final Icon trueIcon;
  final Icon falseIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: AnimatedToggleSwitch<bool>.dual(
        current: current,
        first: false,
        second: true,
        spacing: 50,
        style: const ToggleStyle(
          borderColor: AppColors.gainsboro,
          backgroundColor: AppColors.gainsboro,
        ),
        borderWidth: 5,
        onChanged: onChanged,
        styleBuilder: (value) => const ToggleStyle(
          indicatorColor: AppColors.makara,
        ),
        iconBuilder: (value) => value ? trueIcon : falseIcon,
        textBuilder: (value) => Center(
          child: Text(
            value ? trueLabel : falseLabel,
            style: AppTextStyles.smaller.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.makara,
            ),
          ),
        ),
      ),
    );
  }
}
