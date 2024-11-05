import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_toggle_switch.dart';
import 'package:wishlist/shared/infra/wishlist_service.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/widgets/app_bottom_sheet.dart';
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

    return AnimatedTheme(
      data: currentTheme.copyWith(
        primaryColor: wishlistColor,
        primaryColorDark: wishlistDarkColor,
        appBarTheme: currentTheme.appBarTheme.copyWith(
          backgroundColor: wishlistColor,
        ),
      ),
      child: Column(
        children: [
          AppBar(
            centerTitle: true,
            toolbarHeight: 80,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: const Icon(
                    Icons.color_lens,
                    size: 32,
                  ),
                  onPressed: onChangeColor,
                ),
              ),
            ],
            foregroundColor: AppColors.background,
            title: Text(
              wishlist.name,
              style: AppTextStyles.medium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: wishlistColor,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(25),
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
                          color: wishlistColor,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          text: l10n.save,
                          onPressed: onSaveParams,
                          style: BaseButtonStyle.large,
                          isStretched: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
