import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/infra/current_user_avatar_provider.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/widgets/app_bottom_sheet.dart';
import 'package:wishlist/shared/widgets/app_list_tile.dart';
import 'package:wishlist/shared/widgets/dialogs/confirm_dialog.dart';

class _AvatarOptionsBottomSheet extends ConsumerWidget {
  const _AvatarOptionsBottomSheet({
    required this.hasAvatar,
  });

  final bool hasAvatar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            l10n.avatarOptions,
            style: AppTextStyles.medium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        AppListTile(
          icon: Icons.photo_library,
          title: l10n.chooseFromGallery,
          onTap: () {
            Navigator.pop(context);
            ref.read(currentUserAvatarProvider.notifier).pickAndUploadAvatar();
          },
        ),
        AppListTile(
          icon: Icons.camera_alt,
          title: l10n.takePhoto,
          onTap: () {
            Navigator.pop(context);
            ref.read(currentUserAvatarProvider.notifier).takePhotoAndUpload();
          },
        ),
        if (hasAvatar)
          AppListTile(
            icon: Icons.delete,
            title: l10n.removeAvatar,
            onTap: () {
              Navigator.pop(context);
              final avatarNotifier =
                  ref.read(currentUserAvatarProvider.notifier);
              showConfirmDialog(
                context,
                title: l10n.removeAvatar,
                explanation: l10n.removeAvatarConfirmation,
                onConfirm: () async {
                  await avatarNotifier.deleteAvatar();
                },
              );
            },
          ),
        const Gap(16),
      ],
    );
  }
}

Future<void> showAvatarOptionsBottomSheet(
  BuildContext context, {
  required bool hasAvatar,
}) async {
  await showAppBottomSheet(
    context,
    expandToFillHeight: false,
    body: _AvatarOptionsBottomSheet(
      hasAvatar: hasAvatar,
    ),
  );
}
