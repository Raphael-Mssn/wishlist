import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_toggle_switch.dart';
import 'package:wishlist/shared/infra/utils/scaffold_messenger_extension.dart';
import 'package:wishlist/shared/infra/wishlist_service.dart';
import 'package:wishlist/shared/infra/wishlists_provider.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/utils/get_wishlist_theme.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/widgets/app_bottom_sheet.dart';
import 'package:wishlist/shared/widgets/dialogs/app_dialog.dart';
import 'package:wishlist/shared/widgets/nav_bar_add_button.dart';

class _WishlistSettingsBottomSheet extends ConsumerStatefulWidget {
  const _WishlistSettingsBottomSheet({required this.wishlist});

  final Wishlist wishlist;

  @override
  ConsumerState<_WishlistSettingsBottomSheet> createState() =>
      _WishlistSettingsBottomSheetState();
}

class _WishlistSettingsBottomSheetState
    extends ConsumerState<_WishlistSettingsBottomSheet> {
  late bool isPrivate;
  late bool canOwnerSeeTakenWish;

  void onChangeColor() {}
  void onAddCollaborator() {}

  void onDeleteWishlist() {
    final l10n = context.l10n;

    showAppDialog(
      context,
      title: l10n.deleteWishlist,
      content: const SizedBox.shrink(),
      confirmButtonLabel: l10n.confirmDialogConfirmButtonLabel,
      onConfirm: () async {
        try {
          await ref
              .read(wishlistsProvider.notifier)
              .deleteWishlist(widget.wishlist.id);
          if (mounted) {
            HomeRoute().go(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.deleteWishlistSuccess),
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showGenericError();
          }
        }
      },
      onCancel: () {},
    );
  }

  Future<void> onSaveSettings() async {
    final l10n = context.l10n;

    final visibilityUpdated =
        isPrivate ? WishlistVisibility.private : WishlistVisibility.public;

    final wishlistUpdated = widget.wishlist.copyWith(
      canOwnerSeeTakenWish: canOwnerSeeTakenWish,
      visibility: visibilityUpdated,
    );

    try {
      await ref.read(wishlistServiceProvider).updateWishlistSettings(
            wishlistUpdated,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.updateSuccess),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.genericError),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    isPrivate = widget.wishlist.visibility == WishlistVisibility.private;
    canOwnerSeeTakenWish = widget.wishlist.canOwnerSeeTakenWish;
  }

  @override
  Widget build(BuildContext context) {
    const smallGap = 8.0;
    const largeGap = 24.0;

    final l10n = context.l10n;
    final wishlist = widget.wishlist;
    final wishlistTheme = getWishlistTheme(context, wishlist);

    return AppBottomSheetWithThemeAndAppBarLayout(
      theme: wishlistTheme,
      title: wishlist.name,
      actionIcon: Icons.color_lens,
      onActionTapped: onChangeColor,
      body: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.wishlistVisibility,
                  style: AppTextStyles.small.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.makara,
                  ),
                ),
                const Gap(smallGap),
                WishlistToggleSwitch(
                  current: isPrivate,
                  onChanged: (value) => setState(() => isPrivate = value),
                  trueLabel: l10n.private,
                  falseLabel: l10n.public,
                  trueIcon: const Icon(
                    Icons.lock,
                    color: AppColors.gainsboro,
                  ),
                  falseIcon: const Icon(
                    Icons.lock_open,
                    color: AppColors.gainsboro,
                  ),
                ),
                const Gap(largeGap),
                Text(
                  l10n.seeTakenWishs,
                  style: AppTextStyles.small.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.makara,
                  ),
                ),
                const Gap(smallGap),
                WishlistToggleSwitch(
                  current: canOwnerSeeTakenWish,
                  onChanged: (value) =>
                      setState(() => canOwnerSeeTakenWish = value),
                  trueLabel: l10n.yes,
                  falseLabel: l10n.no,
                  trueIcon: const Icon(
                    Icons.visibility_rounded,
                    color: AppColors.gainsboro,
                  ),
                  falseIcon: const Icon(
                    Icons.visibility_off_rounded,
                    color: AppColors.gainsboro,
                  ),
                ),
                const Gap(largeGap),
                Text(
                  l10n.shareEditionWith,
                  style: AppTextStyles.small.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.makara,
                  ),
                ),
                const Gap(smallGap),
                Row(
                  children: [
                    NavBarAddButton(
                      icon: Icons.person_add_alt_1,
                      onPressed: onAddCollaborator,
                      size: NavBarButtonSize.small,
                    ),
                    const Gap(smallGap),
                    Text(
                      l10n.addCollaborator,
                      style: AppTextStyles.smaller.copyWith(
                        fontWeight: FontWeight.bold,
                        color: wishlistTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Builder(
            // Needed to have the context with wishlist theme
            builder: (context) {
              return SecondaryButton(
                text: l10n.deleteWishlist,
                onPressed: onDeleteWishlist,
                style: BaseButtonStyle.large,
                isStretched: true,
              );
            },
          ),
          const Gap(12),
          PrimaryButton(
            text: l10n.save,
            onPressed: onSaveSettings,
            style: BaseButtonStyle.large,
            isStretched: true,
          ),
        ],
      ),
    );
  }
}

void showWishlistSettingsBottomSheet(BuildContext context, Wishlist wishlist) {
  showAppBottomSheet(
    context,
    body: _WishlistSettingsBottomSheet(wishlist: wishlist),
  );
}
