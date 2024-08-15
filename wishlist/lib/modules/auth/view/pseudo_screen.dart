import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/auth/view/auth_layout.dart';
import 'package:wishlist/shared/infra/app_exception.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/models/profile.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/theme/widgets/primary_button.dart';

class PseudoScreen extends ConsumerStatefulWidget {
  const PseudoScreen({super.key});

  @override
  ConsumerState<PseudoScreen> createState() => _PseudoScreenState();
}

class _PseudoScreenState extends ConsumerState<PseudoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pseudoController = TextEditingController();
  bool _isLoading = false;

  void onSuccess() {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pushReplacementNamed(AppRoutes.home.name);
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.genericError,
              ),
            ),
          );
        default:
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
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await ref.read(userServiceProvider).createUserProfile(
              Profile(
                // TODO: wrap currentUser to avoid null and handle null error
                id: ref.read(supabaseClientProvider).auth.currentUser!.id,
                pseudo: _pseudoController.text,
              ),
            );

        onSuccess();
      } on AppException catch (appException) {
        onError(appException);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AuthLayout(
      formKey: _formKey,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _pseudoController,
              decoration: InputDecoration(
                labelText: l10n.pseudoField,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.validPseudoError;
                }
                return null;
              },
            ),
            const Gap(32),
            PrimaryButton(
              onPressed: onPressed,
              text: l10n.savePseudo,
              style: PrimaryButtonStyle.large,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
