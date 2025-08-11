import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/gen/assets.gen.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_toggle_switch.dart';
import 'package:wishlist/shared/infra/wishlist_service.dart';
import 'package:wishlist/shared/infra/wishlists_provider.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/utils/scaffold_messenger_extension.dart';
import 'package:wishlist/shared/widgets/app_bottom_sheet.dart';
import 'package:wishlist/shared/widgets/dialogs/app_dialog.dart';
import 'package:wishlist/shared/widgets/editable_title.dart';
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
  late bool isPublic = widget.wishlist.visibility == WishlistVisibility.public;
  late bool canOwnerSeeTakenWish = widget.wishlist.canOwnerSeeTakenWish;
  late String wishlistName = widget.wishlist.name;

  void onChangeColor() {
    final l10n = context.l10n;
    var tempColor = AppColors.getColorFromHexValue(widget.wishlist.color);

    showAppDialog(
      context,
      title: l10n.wishlistColor,
      content: Builder(
        builder: (context) {
          return FittedBox(
            child: ColorPicker(
              color: tempColor,
              width: 60,
              height: 60,
              onColorChanged: (color) => tempColor = color,
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.both: false,
                ColorPickerType.accent: false,
                ColorPickerType.custom: true,
                ColorPickerType.primary: false,
              },
              customColorSwatchesAndNames: AppColors.colorSwatches,
              enableShadesSelection: false,
            ),
          );
        },
      ),
      confirmButtonLabel: l10n.confirmDialogConfirmButtonLabel,
      onConfirm: () async {
        try {
          final selectedColor = tempColor;
          final wishlistUpdated = widget.wishlist
              .copyWith(color: AppColors.getHexValue(selectedColor));

          await ref
              .read(wishlistServiceProvider)
              .updateWishlist(wishlistUpdated);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.updateSuccess)),
            );
            Navigator.pop(context);
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
        isPublic ? WishlistVisibility.public : WishlistVisibility.private;

    final wishlistUpdated = widget.wishlist.copyWith(
      name: wishlistName,
      canOwnerSeeTakenWish: canOwnerSeeTakenWish,
      visibility: visibilityUpdated,
    );

    try {
      await ref.read(wishlistServiceProvider).updateWishlist(
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
        ScaffoldMessenger.of(context).showGenericError();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const smallGap = 8.0;
    const largeGap = 16.0;
    const borderRadiusContainer = 24.0;
    const paddingContainer = 16.0;

    final l10n = context.l10n;
    final wishlist = widget.wishlist;
    final currentTheme = Theme.of(context);

    return AppBottomSheetWithThemeAndAppBarLayout(
      theme: currentTheme,
      appBarTitle: EditableTitle(
        initialTitle: wishlist.name,
        onTitleChanged: (newTitle) {
          setState(() {
            wishlistName = newTitle;
          });
        },
      ),
      actionIcon: Icons.color_lens,
      onActionTapped: onChangeColor,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First container
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(borderRadiusContainer),
                      color: AppColors.gainsboro,
                    ),
                    padding: const EdgeInsets.all(paddingContainer),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.wishlistVisibility,
                              style: AppTextStyles.smaller.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.makara,
                              ),
                            ),
                            WishlistToggleSwitch(
                              current: isPublic,
                              onChanged: (value) =>
                                  setState(() => isPublic = value),
                              trueLabel: l10n.public,
                              falseLabel: l10n.private,
                              trueIcon: const Icon(
                                Icons.lock_open,
                                color: AppColors.makara,
                              ),
                              falseIcon: const Icon(
                                Icons.lock,
                                color: AppColors.makara,
                              ),
                            ),
                          ],
                        ),
                        const Gap(largeGap),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.seeTakenWishs,
                              style: AppTextStyles.smaller.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.makara,
                              ),
                            ),
                            WishlistToggleSwitch(
                              current: canOwnerSeeTakenWish,
                              onChanged: (value) =>
                                  setState(() => canOwnerSeeTakenWish = value),
                              trueLabel: l10n.yes,
                              falseLabel: l10n.no,
                              trueIcon: const Icon(
                                Icons.visibility_rounded,
                                color: AppColors.makara,
                              ),
                              falseIcon: const Icon(
                                Icons.visibility_off_rounded,
                                color: AppColors.makara,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(largeGap),

                  // Second container
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.44,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(borderRadiusContainer),
                        color: AppColors.gainsboro,
                      ),
                      padding: const EdgeInsets.all(paddingContainer),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.wishlistSharedWith,
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
                                  color: currentTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Center(
                              child: SvgPicture.asset(
                                Assets.svg.noFriend,
                                height: MediaQuery.sizeOf(context).height / 3.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(largeGap),
                ],
              ),
            ),
          ),
          SecondaryButton(
            text: l10n.deleteWishlist,
            onPressed: onDeleteWishlist,
            style: BaseButtonStyle.large,
            isStretched: true,
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

Future<void> showWishlistSettingsBottomSheet(
  BuildContext context,
  Wishlist wishlist,
) async {
  await showAppBottomSheet(
    context,
    body: _WishlistSettingsBottomSheet(wishlist: wishlist),
  );
}
