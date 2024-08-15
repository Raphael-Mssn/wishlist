import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/auth/view/auth_layout.dart';
import 'package:wishlist/shared/infra/auth_service.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/theme/widgets/primary_button.dart';
import 'package:wishlist/shared/widgets/text_form_fields/input_email.dart';
import 'package:wishlist/shared/widgets/text_form_fields/input_password.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  /// Whether the user is signing in or signing up
  bool _isSigningIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void onSuccess() {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      final nextScreen =
          _isSigningIn ? AppRoutes.home.name : AppRoutes.pseudo.name;
      Navigator.of(context).pushReplacementNamed(nextScreen);
    }
  }

  void onError(AuthException authException) {
    final l10n = context.l10n;

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      final statusCode = authException.statusCode;
      if (statusCode != null) {
        switch (int.parse(statusCode)) {
          case 422:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l10n.userAlreadyRegistered,
                ),
              ),
            );
          case 400:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l10n.invalidLoginCredentials,
                ),
              ),
            );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.genericError,
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
    setState(() {
      _isLoading = true;
    });
    try {
      if (_isSigningIn) {
        await ref.read(authServiceProvider).signIn(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );
      } else {
        await ref.read(authServiceProvider).signUp(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );
      }

      if (mounted) {
        onSuccess();
      }
    } on AuthException catch (authException) {
      onError(authException);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AuthLayout(
      formKey: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputEmail(controller: _emailController),
          const Gap(16),
          InputPassword(
            autofillHints: _isSigningIn
                ? AutofillHints.password
                : AutofillHints.newPassword,
            controller: _passwordController,
            label: l10n.passwordField,
            textInputAction: TextInputAction.done,
          ),
          const Gap(32),
          PrimaryButton(
            text: _isSigningIn ? l10n.signIn : l10n.signUp,
            onPressed: onPressed,
            isLoading: _isLoading,
            style: PrimaryButtonStyle.large,
          ),
          const Gap(16),
          TextButton(
            onPressed: () {
              setState(() {
                _isSigningIn = !_isSigningIn;
              });
            },
            child: Text(
              _isSigningIn ? l10n.dontHaveAccount : l10n.haveAccount,
              style: const TextStyle(
                color: Colors.black,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
