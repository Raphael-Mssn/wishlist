import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/infra/friendship_actions_provider.dart';
import 'package:wishlist/shared/models/app_user.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/widgets/dialogs/app_dialog.dart';

enum FriendDetailsAppBarAction { remove }

class FriendDetailsAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  const FriendDetailsAppBar({super.key, required this.friend});

  final AppUser friend;

  Future<void> _deleteFriend(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;

    try {
      await ref
          .read(friendshipActionsProvider)
          .removeFriendship(friend.user.id);

      if (context.mounted) {
        showAppSnackBar(
          context,
          l10n.removeFriendSuccess,
          type: SnackBarType.success,
        );
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        showGenericError(context);
      }
    }
  }

  Future<void> _onRemoveFriendPressed(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = context.l10n;

    await showAppDialog(
      context,
      title: l10n.friendDetailsRemove,
      content: Text(
        l10n.removeFriendConfirmation,
        style: AppTextStyles.small.copyWith(
          color: AppColors.makara,
        ),
      ),
      confirmButtonLabel: l10n.confirmDialogConfirmButtonLabel,
      onConfirm: () => _deleteFriend(context, ref),
      onCancel: () {},
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    const iconsColor = AppColors.darkGrey;

    final dropdownMenuItemTextStyle = AppTextStyles.smaller.copyWith(
      color: AppColors.darkGrey,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AppBar(
        titleSpacing: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(
          color: iconsColor,
        ),
        title: Align(
          alignment: Alignment.centerRight,
          child: DropdownButton(
            icon: const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.more_vert,
                color: iconsColor,
              ),
            ),
            underline: const SizedBox.shrink(),
            dropdownColor: AppColors.gainsboro,
            elevation: 1,
            style: dropdownMenuItemTextStyle,
            borderRadius: BorderRadius.circular(8),
            onChanged: (value) {
              if (value == FriendDetailsAppBarAction.remove) {
                _onRemoveFriendPressed(context, ref);
              }
            },
            items: [
              DropdownMenuItem(
                value: FriendDetailsAppBarAction.remove,
                child: Text(
                  l10n.friendDetailsRemove,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
