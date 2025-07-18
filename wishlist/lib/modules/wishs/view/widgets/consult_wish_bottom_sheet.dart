import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishs/view/widgets/wish_property.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/infra/wish_taken_by_user_service.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/utils/double_extension.dart';
import 'package:wishlist/shared/utils/scaffold_messenger_extension.dart';
import 'package:wishlist/shared/widgets/app_bottom_sheet.dart';

class _ConsultWishBottomSheet extends ConsumerWidget {
  const _ConsultWishBottomSheet({
    required this.wish,
  });

  final Wish wish;

  Future<void> onOpenLink(BuildContext context, String linkUrl) async {
    final canLaunch = await launchUrl(Uri.parse(linkUrl));
    if (context.mounted && !canLaunch) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.linkNotValid),
        ),
      );
    }
  }

  Future<void> onGiveIt(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(wishTakenByUserServiceProvider).wishTakenByUser(
            wish,
          );
      if (context.mounted) {
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showGenericError();
      }
    }
  }

  Future<void> onCancelGiveIt(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(wishTakenByUserServiceProvider).cancelWishTaken(wish);
      if (context.mounted) {
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showGenericError();
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

    final isWishPending = wish.takenByUser.isEmpty;
    final isWishTakenByMe = wish.takenByUser.any(
      (element) => element.userId == currentUserId,
    );

    return AppBottomSheetWithThemeAndAppBarLayout(
      title: wish.name,
      theme: Theme.of(context),
      actionIcon: Icons.favorite_border,
      onActionTapped: () {},
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
              if (isWishPending)
                PrimaryButton(
                  text: l10n.iWantToGiveIt,
                  style: BaseButtonStyle.large,
                  isStretched: true,
                  onPressed: () => onGiveIt(context, ref),
                )
              else if (isWishTakenByMe)
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
  Wish wish,
) async {
  await showAppBottomSheet(
    context,
    body: _ConsultWishBottomSheet(
      wish: wish,
    ),
  );
}
