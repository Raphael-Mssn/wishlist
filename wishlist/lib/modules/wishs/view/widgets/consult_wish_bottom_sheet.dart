import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_card.dart';
import 'package:wishlist/modules/wishs/view/widgets/wish_property.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/infra/wish_taken_by_user_service.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/utils/double_extension.dart';
import 'package:wishlist/shared/widgets/app_bottom_sheet.dart';
import 'package:wishlist/shared/widgets/dialogs/quantity_selection_dialog.dart';
import 'package:wishlist/shared/widgets/static_title.dart';

class _ConsultWishBottomSheet extends ConsumerWidget {
  const _ConsultWishBottomSheet({
    required this.wish,
    this.cardType,
    this.onWishUpdated,
  });

  final Wish wish;
  final WishlistStatsCardType? cardType;
  final VoidCallback? onWishUpdated;

  Future<void> onOpenLink(BuildContext context, String linkUrl) async {
    final canLaunch = await launchUrl(Uri.parse(linkUrl));
    if (context.mounted && !canLaunch) {
      showAppSnackBar(
        context,
        context.l10n.linkNotValid,
        type: SnackBarType.error,
      );
    }
  }

  Future<void> onGiveIt(BuildContext context, WidgetRef ref) async {
    // Si quantité disponible > 1, afficher le dialog de sélection
    if (wish.availableQuantity > 1) {
      await showQuantitySelectionDialog(context, ref, wish: wish);
      return;
    }

    // Si quantité disponible = 1, réserver directement
    try {
      await ref.read(wishTakenByUserServiceProvider).wishTakenByUser(
            wish,
            quantity: 1,
          );
      if (context.mounted) {
        context.pop();
        showAppSnackBar(
          context,
          context.l10n.wishReservedSuccess,
          type: SnackBarType.success,
        );
      }
    } catch (e) {
      if (context.mounted) {
        showGenericError(context);
      }
    }
  }

  Future<void> onCancelGiveIt(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(wishTakenByUserServiceProvider).cancelWishTaken(wish);
      if (context.mounted) {
        onWishUpdated?.call();
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        showGenericError(context);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final linkUrl = wish.linkUrl;

    final priceInputController = TextEditingController(
      text: wish.price.toStringWithout0OrEmpty(),
    );
    final quantityInputController = TextEditingController(
      text: wish.quantity.toString(),
    );
    final descriptionInputController =
        TextEditingController(text: wish.description);

    const gapWishProperty = 12.0;
    final currentUserId = ref.read(userServiceProvider).getCurrentUserId();

    final isWishTakenByMe = wish.takenByUser.any(
      (element) => element.userId == currentUserId,
    );

    final shouldShowCancelButton =
        cardType == WishlistStatsCardType.booked && isWishTakenByMe;
    final shouldShowGiveItButton =
        cardType == WishlistStatsCardType.pending && wish.availableQuantity > 0;

    return AppBottomSheetWithThemeAndAppBarLayout(
      appBarTitle: StaticTitle(title: wish.name),
      theme: Theme.of(context),
      actionWidget: Icon(
        wish.isFavourite ? Icons.favorite : Icons.favorite_border,
        color: wish.isFavourite ? AppColors.favorite : AppColors.background,
        size: 32,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  WishProperty(
                    icon: Icons.attach_money,
                    label: l10n.wishPriceLabel,
                    inputController: priceInputController,
                    inputTextAlign: TextAlign.center,
                    readOnly: true,
                  ),
                  const Gap(gapWishProperty),
                  WishProperty(
                    icon: Icons.one_x_mobiledata,
                    label: l10n.wishQuantityLabel,
                    inputController: quantityInputController,
                    inputTextAlign: TextAlign.center,
                    readOnly: true,
                  ),
                  const Gap(gapWishProperty),
                  WishProperty(
                    icon: Icons.description_outlined,
                    label: l10n.wishDescriptionLabel,
                    inputController: descriptionInputController,
                    isInputBellow: true,
                    isMultilineInput: true,
                    readOnly: true,
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              if (linkUrl != null && linkUrl.isNotEmpty) ...[
                SecondaryButton(
                  text: l10n.openLink,
                  style: BaseButtonStyle.large,
                  isStretched: true,
                  onPressed: () => onOpenLink(context, linkUrl),
                ),
                const Gap(12),
              ],
              if (shouldShowGiveItButton)
                PrimaryButton(
                  text: l10n.iWantToGiveIt,
                  style: BaseButtonStyle.large,
                  isStretched: true,
                  onPressed: () => onGiveIt(context, ref),
                )
              else if (shouldShowCancelButton)
                PrimaryButton(
                  text: l10n.cancelBooking,
                  style: BaseButtonStyle.large,
                  isStretched: true,
                  onPressed: () => onCancelGiveIt(context, ref),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> showConsultWishBottomSheet(
  BuildContext context,
  Wish wish, {
  WishlistStatsCardType? cardType,
  VoidCallback? onWishUpdated,
}) async {
  await showAppBottomSheet(
    context,
    body: _ConsultWishBottomSheet(
      wish: wish,
      cardType: cardType,
      onWishUpdated: onWishUpdated,
    ),
  );
}
