import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/infra/wishlists_realtime_provider.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/widgets/app_bottom_sheet.dart';
import 'package:wishlist/shared/widgets/dialogs/app_dialog.dart';

Future<void> showMoveWishesDialog(
  BuildContext context, {
  required int currentWishlistId,
  required int wishCount,
  required Future<void> Function(int targetWishlistId) onConfirm,
}) async {
  final selectedWishlistId = ValueNotifier<int?>(null);
  final isConfirmEnabled = ValueNotifier<bool>(false);
  final showConfirmButton = ValueNotifier<bool>(true);

  selectedWishlistId.addListener(() {
    isConfirmEnabled.value = selectedWishlistId.value != null;
  });

  await showAppDialog(
    context,
    title: context.l10n.moveWishes,
    content: _MoveWishesDialogContent(
      currentWishlistId: currentWishlistId,
      wishCount: wishCount,
      selectedWishlistId: selectedWishlistId,
      showConfirmButton: showConfirmButton,
    ),
    confirmButtonLabel: context.l10n.moveButton,
    isConfirmEnabled: isConfirmEnabled,
    showConfirmButton: showConfirmButton,
    onConfirm: () async {
      if (selectedWishlistId.value != null) {
        await onConfirm(selectedWishlistId.value!);
      }
    },
    onCancel: () {},
  );
}

class _MoveWishesDialogContent extends ConsumerWidget {
  const _MoveWishesDialogContent({
    required this.currentWishlistId,
    required this.wishCount,
    required this.selectedWishlistId,
    required this.showConfirmButton,
  });

  final int currentWishlistId;
  final int wishCount;
  final ValueNotifier<int?> selectedWishlistId;
  final ValueNotifier<bool> showConfirmButton;

  Future<void> _showWishlistBottomSheet(
    BuildContext context,
    List<Wishlist> wishlists,
  ) async {
    await showAppBottomSheet(
      context,
      expandToFillHeight: false,
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                context.l10n.selectWishlist,
                textAlign: TextAlign.center,
                style:
                    AppTextStyles.large.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: wishlists.length,
                itemBuilder: (context, index) {
                  return _WishlistListTile(
                    wishlist: wishlists[index],
                    isSelected: selectedWishlistId.value == wishlists[index].id,
                    onTap: () {
                      selectedWishlistId.value = wishlists[index].id;
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final wishlistsAsync = ref.watch(wishlistsRealtimeProvider);

    return wishlistsAsync.when(
      data: (wishlists) {
        final availableWishlists =
            wishlists.where((wl) => wl.id != currentWishlistId).toList();

        showConfirmButton.value = availableWishlists.isNotEmpty;

        // Présélectionner la wishlist la plus récente
        if (availableWishlists.isNotEmpty && selectedWishlistId.value == null) {
          final mostRecent = availableWishlists.reduce(
            (a, b) => a.createdAt.isAfter(b.createdAt) ? a : b,
          );
          selectedWishlistId.value = mostRecent.id;
        }

        if (availableWishlists.isEmpty) {
          return Text(
            l10n.noOtherWishlistsAvailable,
            style: AppTextStyles.small.copyWith(
              color: AppColors.makara,
            ),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              wishCount == 1
                  ? l10n.selectDestinationWishlistSingle
                  : l10n.selectDestinationWishlistMultiple(wishCount),
              style: AppTextStyles.small.copyWith(
                color: AppColors.makara,
              ),
            ),
            const Gap(20),
            _WishlistSelector(
              selectedWishlistId: selectedWishlistId,
              availableWishlists: availableWishlists,
              onTap: () =>
                  _showWishlistBottomSheet(context, availableWishlists),
            ),
          ],
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Text(
        l10n.errorLoadingWishlists,
        style: AppTextStyles.small.copyWith(
          color: AppColors.makara,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _WishlistListTile extends StatelessWidget {
  const _WishlistListTile({
    required this.wishlist,
    required this.isSelected,
    required this.onTap,
  });

  final Wishlist wishlist;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final wishlistColor = AppColors.getColorFromHexValue(wishlist.color);

    return ListTile(
      leading: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: wishlistColor,
          shape: BoxShape.circle,
        ),
      ),
      title: Text(
        wishlist.name,
        style: AppTextStyles.medium.copyWith(
          color: isSelected ? wishlistColor : AppColors.darkGrey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check,
              color: wishlistColor,
            )
          : null,
      onTap: onTap,
    );
  }
}

class _WishlistSelector extends StatelessWidget {
  const _WishlistSelector({
    required this.selectedWishlistId,
    required this.availableWishlists,
    required this.onTap,
  });

  final ValueNotifier<int?> selectedWishlistId;
  final List<Wishlist> availableWishlists;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ValueListenableBuilder<int?>(
      valueListenable: selectedWishlistId,
      builder: (context, selected, _) {
        final selectedWishlist = selected != null
            ? availableWishlists.firstWhere((wl) => wl.id == selected)
            : null;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Ink(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.gainsboro),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      selectedWishlist?.name ?? l10n.selectWishlist,
                      style: AppTextStyles.small.copyWith(
                        color: selectedWishlist != null
                            ? AppColors.darkGrey
                            : AppColors.makara,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.darkGrey,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
