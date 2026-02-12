import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/infra/app_exception.dart';
import 'package:wishlist/shared/infra/auth_service.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/widgets/page_layout.dart';
import 'package:wishlist/shared/widgets/text_form_fields/input_password.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onSuccess() async {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Sign out to clear the temporary recovery session
      await ref.read(authServiceProvider).signOut(context, ref);

      if (mounted) {
        showAppSnackBar(
          context,
          context.l10n.resetPasswordSuccess,
          type: SnackBarType.success,
        );

        AuthRoute().go(context);
      }
    }
  }

  void _onError(AppException appException) {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      final statusCode = appException.statusCode;
      if (statusCode == 422) {
        showAppSnackBar(
          context,
          context.l10n.newPasswordShouldBeDifferent,
          type: SnackBarType.error,
        );
      } else {
        showGenericError(context, error: appException);
      }
    }
  }

  Future<void> _onPressed() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await ref.read(authServiceProvider).resetPassword(
              newPassword: _newPasswordController.text.trim(),
            );

        await _onSuccess();
      } on AppException catch (appException) {
        _onError(appException);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PageLayout(
      title: l10n.resetPasswordTitle,
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InputPassword(
              autofillHints: AutofillHints.newPassword,
              controller: _newPasswordController,
              label: l10n.newPasswordField,
              textInputAction: TextInputAction.next,
              showStrengthIndicator: true,
            ),
            const Gap(16),
            InputPassword(
              autofillHints: AutofillHints.newPassword,
              controller: _confirmPasswordController,
              label: l10n.confirmNewPasswordField,
              textInputAction: TextInputAction.done,
              additionalValidator: (value) {
                if (value != _newPasswordController.text) {
                  return l10n.passwordsDoNotMatch;
                }
                return null;
              },
            ),
            const Gap(32),
            PrimaryButton(
              text: l10n.resetPasswordConfirm,
              onPressed: _onPressed,
              isLoading: _isLoading,
              style: BaseButtonStyle.large,
            ),
          ],
        ),
      ),
    );
  }
}
