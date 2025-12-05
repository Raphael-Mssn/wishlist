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
    return AnimatedToggleSwitch<bool>.dual(
      current: current,
      first: false,
      second: true,
      height: 40,
      style: const ToggleStyle(
        borderColor: AppColors.makara,
        backgroundColor: AppColors.makara,
      ),
      borderWidth: 5,
      onChanged: onChanged,
      styleBuilder: (value) => const ToggleStyle(
        indicatorColor: AppColors.gainsboro,
      ),
      iconBuilder: (value) => value ? trueIcon : falseIcon,
      textBuilder: (value) => Text(
        value ? trueLabel : falseLabel,
        style: AppTextStyles.tiny.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.gainsboro,
        ),
      ),
    );
  }
}
