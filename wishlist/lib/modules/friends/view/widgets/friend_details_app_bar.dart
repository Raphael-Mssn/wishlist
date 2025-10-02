import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/infra/friendships_provider.dart';
import 'package:wishlist/shared/models/app_user.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

enum FriendDetailsAppBarAction { remove }

class FriendDetailsAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  const FriendDetailsAppBar({super.key, required this.friend});

  final AppUser friend;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    final dropdownMenuItemTextStyle = AppTextStyles.smaller.copyWith(
      color: AppColors.darkGrey,
    );

    Future<void> removeFriend() async {
      await ref.read(friendshipsProvider.notifier).removeFriendshipWith(friend);

      if (context.mounted) {
        context.pop();
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AppBar(
        titleSpacing: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.background,
        title: Align(
          alignment: Alignment.centerRight,
          child: DropdownButton(
            icon: const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.more_vert),
            ),
            underline: const SizedBox.shrink(),
            dropdownColor: AppColors.gainsboro,
            elevation: 1,
            style: dropdownMenuItemTextStyle,
            borderRadius: BorderRadius.circular(8),
            onChanged: (value) {
              if (value == FriendDetailsAppBarAction.remove) {
                removeFriend();
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
