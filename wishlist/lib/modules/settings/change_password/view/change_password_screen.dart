import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/infra/app_exception.dart';
import 'package:wishlist/shared/infra/auth_service.dart';
import 'package:wishlist/shared/infra/utils/scaffold_messenger_extension.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/widgets/page_layout.dart';
import 'package:wishlist/shared/widgets/text_form_fields/input_password.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void onSuccess() {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      context.pop();
    }
  }

  void onError(AppException appException) {
    final l10n = context.l10n;

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      final statusCode = appException.statusCode;
      switch (statusCode) {
        case 401:
          ScaffoldMessenger.of(context).showGenericError();
        case 403:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.oldPasswordIncorrect,
              ),
            ),
          );
        case 422:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.newPasswordShouldBeDifferent,
              ),
            ),
          );
      }
    }
  }

  Future<void> onPressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_newPasswordController.text != _confirmNewPasswordController.text) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      await ref.read(authServiceProvider).changePassword(
            oldPassword: _oldPasswordController.text,
            newPassword: _newPasswordController.text,
          );

      if (mounted) {
        onSuccess();
      }
    } on AppException catch (appException) {
      onError(appException);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const gapBetweenFields = Gap(16);

    return Scaffold(
      body: PageLayout(
        title: l10n.changePasswordScreenTitle,
        child: AutofillGroup(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                gapBetweenFields,
                InputPassword(
                  autofillHints: AutofillHints.password,
                  controller: _oldPasswordController,
                  label: l10n.oldPasswordField,
                  textInputAction: TextInputAction.next,
                ),
                gapBetweenFields,
                InputPassword(
                  autofillHints: AutofillHints.newPassword,
                  controller: _newPasswordController,
                  label: l10n.newPasswordField,
                  textInputAction: TextInputAction.next,
                ),
                gapBetweenFields,
                InputPassword(
                  autofillHints: AutofillHints.newPassword,
                  controller: _confirmNewPasswordController,
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
                  text: l10n.changePasswordConfirm,
                  onPressed: onPressed,
                  isLoading: _isLoading,
                  style: BaseButtonStyle.large,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
