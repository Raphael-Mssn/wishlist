import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:wishlist/gen/fonts.gen.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/auth/view/auth_layout.dart';
import 'package:wishlist/shared/infra/auth_service.dart';
import 'package:wishlist/shared/infra/current_user_avatar_provider.dart';
import 'package:wishlist/shared/infra/first_launch_service.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/widgets/text_form_fields/input_email.dart';
import 'package:wishlist/shared/widgets/text_form_fields/input_password.dart';
import 'package:wishlist/shared/widgets/text_form_fields/input_pseudo_or_email.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({
    super.key,
    this.redirectTo,
  });

  final String? redirectTo;

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pseudoOrEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  /// Whether the user is signing in or signing up
  bool _isSigningIn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeSigningInState();
      }
    });
  }

  Future<void> _initializeSigningInState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final firstLaunchService = FirstLaunchService(prefs);
      final isFirstLaunch = firstLaunchService.isFirstLaunch();

      if (mounted) {
        setState(() {
          _isSigningIn = !isFirstLaunch;
        });

        await firstLaunchService.markAsLaunched();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSigningIn = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _pseudoOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void onSuccess() {
    final redirectTo = widget.redirectTo;

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      if (_isSigningIn) {
        ref.read(currentUserAvatarProvider.notifier).refresh();
        if (redirectTo != null && redirectTo.startsWith('/')) {
          context.go(redirectTo);
        } else {
          HomeRoute().go(context);
        }
      } else {
        if (redirectTo != null && redirectTo.startsWith('/')) {
          context.go(
            Uri(
              path: PseudoRoute().location,
              queryParameters: {
                'redirectTo': redirectTo,
              },
            ).toString(),
          );
        } else {
          PseudoRoute().go(context);
        }
      }
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
            showAppSnackBar(
              context,
              l10n.userAlreadyRegistered,
              type: SnackBarType.error,
            );
          case 400:
            showAppSnackBar(
              context,
              l10n.invalidLoginCredentials,
              type: SnackBarType.error,
            );
          case 404:
            showAppSnackBar(
              context,
              l10n.invalidLoginCredentials,
              type: SnackBarType.error,
            );
        }
      } else {
        showGenericError(context);
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
              identifier: _pseudoOrEmailController.text.trim(),
              password: _passwordController.text.trim(),
            );
      } else {
        await ref.read(authServiceProvider).signUp(
              email: _pseudoOrEmailController.text.trim(),
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

    final emailOrPseudoInput = _isSigningIn
        ? InputPseudoOrEmail(
            controller: _pseudoOrEmailController,
          )
        : InputEmail(controller: _pseudoOrEmailController);

    return AuthLayout(
      formKey: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          emailOrPseudoInput,
          const Gap(16),
          InputPassword(
            autofillHints: _isSigningIn
                ? AutofillHints.password
                : AutofillHints.newPassword,
            controller: _passwordController,
            label: l10n.passwordField,
            textInputAction: TextInputAction.done,
            showStrengthIndicator: !_isSigningIn,
          ),
          const Gap(32),
          PrimaryButton(
            text: _isSigningIn ? l10n.signIn : l10n.signUp,
            onPressed: onPressed,
            isLoading: _isLoading,
            style: BaseButtonStyle.large,
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
              style: AppTextStyles.smaller.copyWith(
                fontFamily: FontFamily.plusJakartaSans,
                color: Colors.black,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Gap(8),
          TextButton(
            onPressed: () => ForgotPasswordRoute().push(context),
            child: Text(
              l10n.forgotPasswordButton,
              style: AppTextStyles.smaller.copyWith(
                decoration: TextDecoration.underline,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
