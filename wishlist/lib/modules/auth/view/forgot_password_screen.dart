import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/infra/app_exception.dart';
import 'package:wishlist/shared/infra/auth_service.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/widgets/page_layout.dart';
import 'package:wishlist/shared/widgets/text_form_fields/input_email.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSuccess() {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      showAppSnackBar(
        context,
        context.l10n.forgotPasswordEmailSent,
        type: SnackBarType.success,
      );
      context.pop();
    }
  }

  void _onError(AppException appException) {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      showGenericError(context, error: appException);
    }
  }

  Future<void> _onPressed() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await ref.read(authServiceProvider).sendPasswordResetEmail(
              email: _emailController.text.trim(),
              ref: ref,
            );

        _onSuccess();
      } on AppException catch (appException) {
        _onError(appException);
      } on AuthException catch (authException) {
        _onError(
          AppException(
            statusCode: int.tryParse(authException.statusCode ?? '500') ?? 500,
            message: authException.message,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PageLayout(
      title: l10n.forgotPasswordTitle,
      child: Form(
        key: _formKey,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.forgotPasswordDescription,
                style: AppTextStyles.small,
              ),
              const Gap(16),
              InputEmail(controller: _emailController),
              const Gap(32),
              PrimaryButton(
                text: l10n.forgotPasswordSendButton,
                onPressed: _onPressed,
                isLoading: _isLoading,
                style: BaseButtonStyle.large,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
