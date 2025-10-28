import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/gen/assets.gen.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_toggle_switch.dart';
import 'package:wishlist/shared/infra/wish_service.dart';
import 'package:wishlist/shared/infra/wishlist_actions_provider.dart';
import 'package:wishlist/shared/infra/wishlist_service.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/widgets/app_bottom_sheet.dart';
import 'package:wishlist/shared/widgets/dialogs/app_dialog.dart';
import 'package:wishlist/shared/widgets/editable_title.dart';
import 'package:wishlist/shared/widgets/nav_bar_add_button.dart';
import 'package:wishlist/shared/widgets/text_form_fields/validators/not_null_validator.dart';

class _WishlistSettingsBottomSheet extends ConsumerStatefulWidget {
  const _WishlistSettingsBottomSheet({required this.wishlist});

  final Wishlist wishlist;

  @override
  ConsumerState<_WishlistSettingsBottomSheet> createState() =>
      _WishlistSettingsBottomSheetState();
}

class _WishlistSettingsBottomSheetState
    extends ConsumerState<_WishlistSettingsBottomSheet>
    with WidgetsBindingObserver {
  late bool isPublic = widget.wishlist.visibility == WishlistVisibility.public;
  late bool canOwnerSeeTakenWish = widget.wishlist.canOwnerSeeTakenWish;
  late String wishlistName = widget.wishlist.name;
  bool _isKeyboardVisible = false;
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = View.of(context).viewInsets.bottom;
    final isKeyboardVisible = bottomInset > 0;

    if (_isKeyboardVisible != isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = isKeyboardVisible;
      });
    }
  }

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
            showAppSnackBar(
              context,
              l10n.updateSuccess,
              type: SnackBarType.success,
            );
            Navigator.pop(context);
          }
        } catch (e) {
          if (mounted) {
            showGenericError(context);
          }
        }
      },
      onCancel: () {},
    );
  }

  void onAddCollaborator() {}

  Future onDeleteWishlist() async {
    final l10n = context.l10n;

    try {
      final hasWishes = await ref
          .read(wishServiceProvider)
          .hasWishesInWishlist(widget.wishlist.id);

      if (mounted) {
        await showAppDialog(
          context,
          title: l10n.deleteWishlist,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.deleteWishlistConfirmation,
                style: AppTextStyles.small.copyWith(
                  color: AppColors.makara,
                ),
              ),
              if (hasWishes) ...[
                const Gap(8),
                Text(
                  l10n.deleteWishlistWishesWarning,
                  style: AppTextStyles.smaller.copyWith(
                    color: AppColors.makara,
                  ),
                ),
              ],
            ],
          ),
          confirmButtonLabel: l10n.confirmDialogConfirmButtonLabel,
          onConfirm: () async {
            try {
              // ✅ Utiliser wishlistActionsProvider, Realtime met à jour l'UI automatiquement
              await ref
                  .read(wishlistActionsProvider)
                  .deleteWishlist(widget.wishlist.id);
              if (mounted) {
                HomeRoute().go(context);
                showAppSnackBar(
                  context,
                  l10n.deleteWishlistSuccess,
                  type: SnackBarType.success,
                );
              }
            } catch (e) {
              if (mounted) {
                showGenericError(context);
              }
            }
          },
          onCancel: () {},
        );
      }
    } catch (e) {
      if (mounted) {
        showGenericError(context);
      }
    }
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
        showAppSnackBar(
          context,
          l10n.updateSuccess,
          type: SnackBarType.success,
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showGenericError(context);
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

    return Form(
      key: _formKey,
      child: AppBottomSheetWithThemeAndAppBarLayout(
        theme: currentTheme,
        appBarTitle: EditableTitle(
          initialTitle: wishlist.name,
          onTitleChanged: (newTitle) {
            setState(() {
              _isFormValid = _formKey.currentState?.validate() ?? false;
              wishlistName = newTitle;
            });
          },
          validator: (value) => notNullValidator(value, l10n),
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
                                onChanged: (value) => setState(
                                  () => canOwnerSeeTakenWish = value,
                                ),
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
                                  height:
                                      MediaQuery.sizeOf(context).height / 3.5,
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
            if (_isKeyboardVisible) ...[
              Transform.translate(
                offset: const Offset(0, -1),
                child: Container(
                  height: 20,
                  decoration: const BoxDecoration(
                    color: AppColors.gainsboro,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                ),
              ),
            ],
            if (!_isKeyboardVisible) ...[
              SecondaryButton(
                text: l10n.deleteWishlist,
                onPressed: onDeleteWishlist,
                style: BaseButtonStyle.large,
                isStretched: true,
              ),
            ],
            const Gap(12),
            PrimaryButton(
              text: l10n.save,
              onPressed: _isFormValid ? onSaveSettings : null,
              style: BaseButtonStyle.large,
              isStretched: true,
            ),
          ],
        ),
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
