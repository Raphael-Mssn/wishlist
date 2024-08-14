import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.formKey,
    required this.child,
  });

  final GlobalKey<FormState> formKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: AutofillGroup(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Gap(48),
                  Text(
                    context.l10n.appTitle,
                    style: AppTextStyles.title,
                    textAlign: TextAlign.center,
                  ),
                  const Gap(16),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
