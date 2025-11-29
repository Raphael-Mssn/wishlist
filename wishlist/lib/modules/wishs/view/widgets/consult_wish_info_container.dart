import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_card.dart';
import 'package:wishlist/modules/wishs/view/widgets/consult_box_shadow.dart';
import 'package:wishlist/modules/wishs/view/widgets/scrollable_content_with_indicator.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/infra/wish_taken_by_user_service.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/utils/formatters.dart';
import 'package:wishlist/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:wishlist/shared/widgets/dialogs/quantity_selection_dialog.dart';

class ConsultWishInfoContainer extends ConsumerWidget {
  const ConsultWishInfoContainer({
    super.key,
    required this.wish,
    required this.descriptionText,
    this.isMyWishlist = false,
    this.cardType,
  });

  final Wish wish;
  final String descriptionText;
  final bool isMyWishlist;
  final WishlistStatsCardType? cardType;

  void _onOpenLinkTap(String linkUrl) {
    launchUrl(Uri.parse(linkUrl));
  }

  Future<void> _onGiveItTap(BuildContext context, WidgetRef ref) async {
    final currentUserId = ref.read(userServiceProvider).getCurrentUserId();
    final isWishTakenByMe = wish.takenByUser.any(
      (element) => element.userId == currentUserId,
    );

    var currentQuantity = 0;
    if (isWishTakenByMe) {
      final userReservation = wish.takenByUser.firstWhere(
        (element) => element.userId == currentUserId,
      );
      currentQuantity = userReservation.quantity;
    }

    // Si l'utilisateur a déjà réservé OU si quantité disponible > 1,
    // afficher le dialog de sélection
    if (isWishTakenByMe || wish.availableQuantity > 1) {
      await showQuantitySelectionDialog(
        context,
        ref,
        wish: wish,
        initialQuantity: isWishTakenByMe ? currentQuantity : 1,
        isModifying: isWishTakenByMe,
      );
      return;
    }

    // Si quantité disponible = 1 et pas encore réservé, réserver directement
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

  Future<void> _onCancelGiveItTap(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;

    await showConfirmDialog(
      context,
      title: l10n.cancelBookingDialogTitle,
      explanation: l10n.cancelBookingDialogExplanation,
      onConfirm: () async {
        try {
          await ref.read(wishTakenByUserServiceProvider).cancelWishTaken(wish);

          if (context.mounted) {
            context.pop();
          }
        } catch (e) {
          if (context.mounted) {
            showGenericError(context);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final linkUrl = wish.linkUrl;

    final currentUserId = ref.read(userServiceProvider).getCurrentUserId();

    final isWishTakenByMe = wish.takenByUser.any(
      (element) => element.userId == currentUserId,
    );

    final hasAvailableQuantity = wish.availableQuantity > 0;

    // Si on vient de l'onglet "réservés", on affiche modifier + annuler
    final isFromBookedTab = cardType == WishlistStatsCardType.booked;
    final shouldShowGiveItButton =
        !isWishTakenByMe && hasAvailableQuantity && !isFromBookedTab;
    final shouldShowModifyButton = isWishTakenByMe && hasAvailableQuantity;
    final shouldShowCancelButton = isWishTakenByMe && isFromBookedTab;

    final price = wish.price;
    final hasLinkUrl = linkUrl != null && linkUrl.isNotEmpty;

    const spacing = 12.0;

    late final bool showPrimaryAction;
    late final VoidCallback? primaryActionOnPressed;
    late final String primaryActionText;

    if (isMyWishlist) {
      showPrimaryAction = true;
      primaryActionOnPressed = () =>
          EditWishRoute(wishlistId: wish.wishlistId, wishId: wish.id)
              .push(context);
      primaryActionText = l10n.editButton;
    } else if (shouldShowGiveItButton || shouldShowModifyButton) {
      showPrimaryAction = true;
      primaryActionOnPressed = () => _onGiveItTap(context, ref);
      primaryActionText =
          shouldShowGiveItButton ? l10n.iWantToGiveIt : l10n.modifyBooking;
    } else {
      showPrimaryAction = false;
      primaryActionOnPressed = null;
      primaryActionText = '';
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height / 1.8,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          boxShadow: [consultBoxShadow],
        ),
        child: Container(
          padding: const EdgeInsets.all(16).copyWith(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      wish.name,
                      style: AppTextStyles.medium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Gap(8),
                  if (hasLinkUrl)
                    IconButton(
                      onPressed: () => _onOpenLinkTap(linkUrl),
                      icon: const Icon(
                        Icons.open_in_new,
                        color: AppColors.makara,
                        size: 32,
                      ),
                      iconSize: 32,
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      wish.isFavourite ? Icons.favorite : Icons.favorite_border,
                      color: wish.isFavourite
                          ? AppColors.favorite
                          : AppColors.makara,
                      size: 32,
                    ),
                  ),
                ],
              ),
              if (price != null)
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    Formatters.currency(price),
                    style: AppTextStyles.small,
                  ),
                ),
              const Gap(spacing),
              SizedBox(
                width: double.infinity,
                child: Text(
                  l10n.wishDescriptionLabel,
                  style: AppTextStyles.small.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Gap(spacing),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.gainsboro,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ScrollableContentWithIndicator(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            descriptionText,
                            style: AppTextStyles.smaller,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Gap(spacing * 3),
              Column(
                mainAxisSize: MainAxisSize.min,
                spacing: spacing,
                children: [
                  if (!isMyWishlist && shouldShowCancelButton)
                    SecondaryButton(
                      style: BaseButtonStyle.medium,
                      onPressed: () => _onCancelGiveItTap(context, ref),
                      text: l10n.cancelBooking,
                      isStretched: true,
                    ),
                  if (showPrimaryAction)
                    PrimaryButton(
                      style: BaseButtonStyle.medium,
                      onPressed: primaryActionOnPressed,
                      text: primaryActionText,
                      isStretched: true,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
