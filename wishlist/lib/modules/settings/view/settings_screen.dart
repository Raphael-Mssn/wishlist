import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/settings/widgets/settings_line.dart';
import 'package:wishlist/modules/settings/widgets/settings_section.dart';
import 'package:wishlist/shared/infra/auth_service.dart';
import 'package:wishlist/shared/infra/current_user_profile_provider.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/widgets/avatar/editable_avatar.dart';
import 'package:wishlist/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:wishlist/shared/widgets/page_layout.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void onSignOutTap(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    showConfirmDialog(
      context,
      title: l10n.settingsScreenDisconnectDialogTitle,
      explanation: l10n.settingsScreenDisconnectDialogExplanation,
      onConfirm: () async {
        await ref.read(authServiceProvider).signOut(context, ref);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final currentUserEmail =
        ref.read(userServiceProvider).getCurrentUserEmail();
    final currentUserProfile = ref.watch(currentUserProfileProvider);

    return PageLayout(
      title: l10n.settingsScreenTitle,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Gap(8),
              Column(
                children: [
                  const EditableAvatar(),
                  const Gap(16),
                  currentUserProfile.when(
                    loading: CircularProgressIndicator.new,
                    data: (currentUser) {
                      return Text(
                        currentUser.profile.pseudo,
                        style: AppTextStyles.small.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                    error: (error, stackTrace) => const SizedBox.shrink(),
                  ),
                  Text(
                    currentUserEmail,
                    style: AppTextStyles.smaller.copyWith(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Gap(24),
              SettingsSection(
                title: l10n.settingsGeneral,
                children: [
                  SettingsLine(
                    title: l10n.settingsScreenPseudoModify,
                    onTap: () {
                      ChangePseudoRoute().push(context);
                    },
                  ),
                  SettingsLine(
                    title: l10n.settingsScreenPasswordModify,
                    onTap: () {
                      ChangePasswordRoute().push(context);
                    },
                  ),
                ],
              ),
              const Gap(24),
              PrimaryButton(
                text: l10n.settingsScreenDisconnect,
                onPressed: () => onSignOutTap(context, ref),
                style: BaseButtonStyle.medium,
              ),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}
