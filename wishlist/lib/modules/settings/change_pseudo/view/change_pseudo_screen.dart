import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/infra/app_exception.dart';
import 'package:wishlist/shared/infra/current_user_profile_provider.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/models/app_user.dart';
import 'package:wishlist/shared/models/profile.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/widgets/page_layout.dart';
import 'package:wishlist/shared/widgets/text_form_fields/validators/pseudo_validator.dart';

class ChangePseudoScreen extends ConsumerWidget {
  const ChangePseudoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final currentUserProfile = ref.watch(currentUserProfileProvider);

    return Scaffold(
      body: PageLayout(
        title: l10n.changePseudoScreenTitle,
        child: currentUserProfile.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                showGenericError(context, error: error);
              }
            });
            return const SizedBox.shrink();
          },
          data: (currentUser) => _ChangePseudoForm(currentUser: currentUser),
        ),
      ),
    );
  }
}

class _ChangePseudoForm extends ConsumerStatefulWidget {
  const _ChangePseudoForm({required this.currentUser});

  final AppUser currentUser;

  @override
  ConsumerState<_ChangePseudoForm> createState() => _ChangePseudoFormState();
}

class _ChangePseudoFormState extends ConsumerState<_ChangePseudoForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _pseudoController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pseudoController =
        TextEditingController(text: widget.currentUser.profile.pseudo);
  }

  @override
  void dispose() {
    _pseudoController.dispose();
    super.dispose();
  }

  void _onSuccess() {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      showAppSnackBar(
        context,
        context.l10n.changePseudoSuccess,
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
        await ref.read(userServiceProvider).updateUserProfile(
              Profile(
                id: widget.currentUser.profile.id,
                pseudo: _pseudoController.text.trim(),
                avatarUrl: widget.currentUser.profile.avatarUrl,
              ),
            );

        _onSuccess();
      } on AppException catch (appException) {
        _onError(appException);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Gap(16),
          TextFormField(
            controller: _pseudoController,
            decoration: InputDecoration(
              label: Text(l10n.newPseudoField),
            ),
            textInputAction: TextInputAction.done,
            autofocus: true,
            validator: (value) => pseudoValidator(value, l10n),
          ),
          const Gap(32),
          PrimaryButton(
            text: l10n.changePseudoConfirm,
            onPressed: _onPressed,
            isLoading: _isLoading,
            style: BaseButtonStyle.large,
          ),
        ],
      ),
    );
  }
}
