import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/infra/auth_service.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:wishlist/shared/widgets/page_layout.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final currentUserEmail =
        ref.read(userServiceProvider).getCurrentUserEmail();

    return PageLayout(
      title: l10n.settingsScreenTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Gap(8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.settingsScreenEmail,
                      style: AppTextStyles.smaller.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currentUserEmail,
                      style: AppTextStyles.smaller.copyWith(
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(16),
              PrimaryButton(
                text: l10n.settingsScreenEmailModify,
                onPressed: () {},
                style: BaseButtonStyle.medium,
              ),
            ],
          ),
          const Gap(40),
          PrimaryButton(
            text: l10n.settingsScreenDisconnect,
            onPressed: () {
              showConfirmDialog(
                context,
                title: l10n.settingsScreenDisconnectDialogTitle,
                explanation: l10n.settingsScreenDisconnectDialogExplanation,
                onConfirm: () async {
                  await ref.read(authServiceProvider).signOut(context, ref);
                },
              );
            },
            style: BaseButtonStyle.medium,
          ),
          const Gap(24),
          PrimaryButton(
            text: l10n.settingsScreenPasswordModify,
            onPressed: () {
              ChangePasswordRoute().push(context);
            },
            style: BaseButtonStyle.medium,
          ),
          const Gap(24),
          PrimaryButton(
            text: l10n.settingsScreenDeleteAccount,
            onPressed: () {},
            style: BaseButtonStyle.medium,
          ),
        ],
      ),
    );
  }
}
