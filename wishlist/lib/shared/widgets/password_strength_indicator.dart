import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/widgets/text_form_fields/validators/password_validator.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    const validColor = AppColors.darkGrey;
    const invalidColor = AppColors.makara;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final password = value.text;
        final l10n = context.l10n;

        final requirements = [
          _Requirement(
            label: l10n.passwordRequirementMinLength,
            isValid: PasswordValidator.hasMinLength(password),
          ),
          _Requirement(
            label: l10n.passwordRequirementUppercase,
            isValid: PasswordValidator.hasUppercase(password),
          ),
          _Requirement(
            label: l10n.passwordRequirementLowercase,
            isValid: PasswordValidator.hasLowercase(password),
          ),
          _Requirement(
            label: l10n.passwordRequirementNumber,
            isValid: PasswordValidator.hasNumber(password),
          ),
          _Requirement(
            label: l10n.passwordRequirementSpecialChar,
            isValid: PasswordValidator.hasSpecialChar(password),
          ),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: requirements
              .map(
                (requirement) => _AnimatedRequirementRow(
                  requirement: requirement,
                  validColor: validColor,
                  invalidColor: invalidColor,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _AnimatedRequirementRow extends StatelessWidget {
  const _AnimatedRequirementRow({
    required this.requirement,
    required this.validColor,
    required this.invalidColor,
  });

  final _Requirement requirement;
  final Color validColor;
  final Color invalidColor;

  @override
  Widget build(BuildContext context) {
    final targetColor = requirement.isValid ? validColor : invalidColor;
    final targetIcon =
        requirement.isValid ? Icons.check_circle : Icons.radio_button_unchecked;

    return Row(
      children: [
        AnimatedSwitcher(
          duration: kThemeAnimationDuration,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: Icon(
            targetIcon,
            key: ValueKey('${requirement.isValid}_${requirement.label}'),
            size: 16,
            color: targetColor,
          ),
        ),
        const Gap(8),
        AnimatedDefaultTextStyle(
          duration: kThemeAnimationDuration,
          curve: Curves.easeInOut,
          style: TextStyle(
            fontSize: 12,
            color: targetColor,
          ),
          child: Text(requirement.label),
        ),
      ],
    );
  }
}

class _Requirement {
  const _Requirement({
    required this.label,
    required this.isValid,
  });

  final String label;
  final bool isValid;
}
