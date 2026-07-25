import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/infra/completed_wish_mutations_provider.dart';
import 'package:wishlist/shared/models/completed_wish_with_details/completed_wish_with_details.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/widgets/app_bottom_sheet.dart';
import 'package:wishlist/shared/widgets/dialogs/quantity_selection_dialog.dart';

Future<void> showUncompleteWishBottomSheet(
  BuildContext context,
  CompletedWishWithDetails item,
) async {
  await showAppBottomSheet(
    context,
    expandToFillHeight: false,
    body: _UncompleteWishBody(item: item),
  );
}

class _UncompleteWishBody extends ConsumerWidget {
  const _UncompleteWishBody({required this.item});

  final CompletedWishWithDetails item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final mutationState = ref.watch(completedWishMutationsProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.unmarkWishConfirmTitle,
            style: AppTextStyles.titleSmall,
            textAlign: TextAlign.center,
          ),
          const Gap(8),
          Text(
            item.wish.name,
            style: AppTextStyles.small.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(16),
          Text(
            l10n.unmarkWishConfirmMessage(item.fromWishlistName),
            style: AppTextStyles.small.copyWith(color: AppColors.makara),
            textAlign: TextAlign.center,
          ),
          const Gap(24),
          PrimaryButton(
            style: BaseButtonStyle.medium,
            text: l10n.unmarkWishAsCompleted,
            isLoading: mutationState.isLoading,
            onPressed: () async {
              try {
                await ref
                    .read(completedWishMutationsProvider.notifier)
                    .unmarkAsCompleted(item.wish.id);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  showAppSnackBar(
                    context,
                    l10n.updateSuccess,
                    type: SnackBarType.success,
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  showGenericError(context, error: e);
                }
              }
            },
            isStretched: true,
          ),
          if (item.wish.quantity > 1) ...[
            const Gap(8),
            SecondaryButton(
              style: BaseButtonStyle.medium,
              text: l10n.modifyCompletedQuantity,
              onPressed: () async {
                final confirmed = await showCompleteWishQuantityDialog(
                  context,
                  ref,
                  wish: item.wish,
                  initialQuantity: item.quantity,
                  isModifying: true,
                );
                if (confirmed && context.mounted) {
                  Navigator.of(context).pop();
                  showAppSnackBar(
                    context,
                    l10n.updateSuccess,
                    type: SnackBarType.success,
                  );
                }
              },
              isStretched: true,
            ),
          ],
          const Gap(8),
          SecondaryButton(
            style: BaseButtonStyle.medium,
            text: l10n.cancelButton,
            onPressed: () => Navigator.of(context).pop(),
            isStretched: true,
          ),
        ],
      ),
    );
  }
}
