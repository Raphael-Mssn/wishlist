import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wishlist/app/config/deeplink_config.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishlists/infra/wishlist_screen_data_realtime_provider.dart';
import 'package:wishlist/modules/wishlists/view/widgets/move_wishes_dialog.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_app_bar.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_floating_actions.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_screen_body.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_settings_bottom_sheet.dart';
import 'package:wishlist/modules/wishlists/view/wishlist_screen_notifier.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/utils/get_wishlist_theme.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/widgets/dialogs/confirm_dialog.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({
    super.key,
    required this.wishlistId,
  });

  final int wishlistId;

  Future<void> _deleteSelectedWishs(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final notifier =
        ref.read(wishlistScreenNotifierProvider(wishlistId).notifier);
    final count =
        ref.read(wishlistScreenNotifierProvider(wishlistId))
            .selectedWishIds.length;
    final l10n = context.l10n;

    final explanation = count == 1
        ? l10n.deleteSelectedWishConfirmation
        : l10n.deleteSelectedWishesConfirmation(count);

    await showConfirmDialog(
      context,
      title: l10n.deleteSelectedWishes,
      explanation: explanation,
      onConfirm: () async {
        try {
          await notifier.deleteSelectedWishs();
          if (context.mounted) {
            showAppSnackBar(
              context,
              count == 1
                  ? l10n.deleteWishSuccess
                  : l10n.wishesDeleted(count),
              type: SnackBarType.success,
            );
          }
        } catch (e) {
          if (context.mounted) {
            showGenericError(context, error: e);
          }
        }
      },
    );
  }

  Future<void> _moveSelectedWishs(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final notifier =
        ref.read(wishlistScreenNotifierProvider(wishlistId).notifier);
    final count =
        ref.read(wishlistScreenNotifierProvider(wishlistId))
            .selectedWishIds.length;
    final l10n = context.l10n;

    await showMoveWishesDialog(
      context,
      currentWishlistId: wishlistId,
      wishCount: count,
      onConfirm: (targetWishlistId) async {
        try {
          await notifier.moveSelectedWishs(targetWishlistId);
          if (context.mounted) {
            showAppSnackBar(
              context,
              l10n.wishesMoved(count),
              type: SnackBarType.success,
            );
          }
        } catch (e) {
          if (context.mounted) {
            showGenericError(context, error: e);
          }
        }
      },
    );
  }

  Future<void> _shareWishlist(
    BuildContext context,
    Wishlist wishlist,
  ) async {
    final wishlistPath = WishlistRoute(wishlistId: wishlist.id).location;
    final deeplink =
        DeeplinkConfig.buildDeeplinkUri(path: wishlistPath).toString();

    try {
      await SharePlus.instance.share(
        ShareParams(text: '${wishlist.name}\n$deeplink'),
      );
    } catch (e) {
      if (context.mounted) {
        showGenericError(context, error: e);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenState =
        ref.watch(wishlistScreenNotifierProvider(wishlistId));
    final notifier =
        ref.read(wishlistScreenNotifierProvider(wishlistId).notifier);
    final wishlistScreenData =
        ref.watch(wishlistScreenDataRealtimeProvider(wishlistId));

    return wishlistScreenData.when(
      data: (data) {
        final wishlist = data.wishlist;
        final wishlistTheme = getWishlistTheme(context, wishlist);
        final isMyWishlist = wishlist.idOwner ==
            ref.read(userServiceProvider).getCurrentUserId();
        final canShareWishlist =
            wishlist.visibility == WishlistVisibility.public;

        notifier.cacheWishlistTheme(wishlist.id, wishlistTheme);

        return AnimatedTheme(
          data: wishlistTheme,
          child: Builder(
            builder: (context) {
              return PopScope(
                canPop: !screenState.isSelectionMode,
                onPopInvokedWithResult: (didPop, result) {
                  if (!didPop && screenState.isSelectionMode) {
                    notifier.exitSelectionMode();
                  }
                },
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: WishlistAppBar(
                    title: wishlist.name,
                    wishlistTheme: wishlistTheme,
                    isMyWishlist: isMyWishlist,
                    canShareWishlist: canShareWishlist,
                    onShare: () => _shareWishlist(
                      context,
                      wishlist,
                    ),
                    onSettings: () =>
                        showWishlistSettingsBottomSheet(
                      context,
                      wishlist,
                    ),
                  ),
                  body: SafeArea(
                    child: Stack(
                      children: [
                        WishlistScreenBody(
                          wishlistId: wishlistId,
                          wishlistScreenData: data,
                          isMyWishlist: isMyWishlist,
                        ),
                        if (isMyWishlist)
                          WishlistFloatingActions(
                            wishlistId: wishlistId,
                            wishlistTheme: wishlistTheme,
                            onAdd: () => CreateWishRoute(
                              wishlistId: wishlist.id,
                            ).push(context),
                            onDelete: () =>
                                _deleteSelectedWishs(context, ref),
                            onMove: () =>
                                _moveSelectedWishs(context, ref),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(backgroundColor: AppColors.background),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(backgroundColor: AppColors.background),
        body: const SizedBox.shrink(),
      ),
    );
  }

}
