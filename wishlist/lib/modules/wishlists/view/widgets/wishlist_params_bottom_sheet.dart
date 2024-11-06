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
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/widgets/app_bottom_sheet.dart';
import 'package:wishlist/shared/widgets/dialogs/app_dialog.dart';
import 'package:wishlist/shared/widgets/nav_bar_add_button.dart';

class WishlistParamsBottomSheet extends ConsumerStatefulWidget {
  const WishlistParamsBottomSheet({super.key, required this.wishlist});

  final Wishlist wishlist;

  @override
  ConsumerState<WishlistParamsBottomSheet> createState() =>
      _WishlistParamsBottomSheetState();
}

class _WishlistParamsBottomSheetState
    extends ConsumerState<WishlistParamsBottomSheet> {
  late bool isPrivate;
  late bool canOwnerSeeTakenWish;

  void onChangeColor() {}
  void onAddCollaborator() {}

  void onDeleteWishlist(BuildContext context) {
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
          if (context.mounted) {
            HomeRoute().go(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.deleteWishlistSuccess),
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showGenericError(
              context,
            );
          }
        }
      },
      onCancel: () {},
    );
  }

  Future<void> onSaveParams() async {
    final l10n = context.l10n;

    final visibilityUpdated =
        isPrivate ? WishlistVisibility.private : WishlistVisibility.public;

    final wishlistUpdated = widget.wishlist.copyWith(
      canOwnerSeeTakenWish: canOwnerSeeTakenWish,
      visibility: visibilityUpdated,
    );

    try {
      await ref.read(wishlistServiceProvider).updateWishlistParams(
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
    final wishlistColor = AppColors.getColorFromHexValue(wishlist.color);
    final wishlistDarkColor = AppColors.darken(wishlistColor);
    final currentTheme = Theme.of(context);
    final wishlistTheme = currentTheme.copyWith(
      primaryColor: wishlistColor,
      primaryColorDark: wishlistDarkColor,
      appBarTheme: currentTheme.appBarTheme.copyWith(
        backgroundColor: wishlistColor,
      ),
    );

    return AppBottomSheetWithThemeAndAppBarLayout(
      theme: wishlistTheme,
      title: wishlist.name,
      actionIcon: const Icon(
        Icons.color_lens,
        size: 32,
      ),
      onActionTapped: onChangeColor,
      body: Column(
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
            onChanged: (value) => setState(() => canOwnerSeeTakenWish = value),
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
                  color: wishlistColor,
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Builder(
                  // Needed to have the context with wishlist theme
                  builder: (context) {
                    return SecondaryButton(
                      text: l10n.deleteWishlist,
                      onPressed: () => onDeleteWishlist(context),
                      style: BaseButtonStyle.large,
                      isStretched: true,
                    );
                  },
                ),
                const Gap(12),
                PrimaryButton(
                  text: l10n.save,
                  onPressed: onSaveParams,
                  style: BaseButtonStyle.large,
                  isStretched: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showWishlistParamsBottomSheet(BuildContext context, Wishlist wishlist) {
  showAppBottomSheet(
    context,
    body: WishlistParamsBottomSheet(wishlist: wishlist),
  );
}
