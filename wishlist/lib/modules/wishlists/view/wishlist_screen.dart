import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wishlist/app/config/deeplink_config.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishlists/infra/wishlist_screen_data_realtime_provider.dart';
import 'package:wishlist/modules/wishlists/view/widgets/move_wishes_dialog.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_app_bar.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_content.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_floating_actions.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_search_bar.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_settings_bottom_sheet.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_card.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_section.dart';
import 'package:wishlist/modules/wishlists/view/wishlist_screen_notifier.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/infra/wish_mutations_provider.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/providers/wishlist_theme_provider.dart';
import 'package:wishlist/shared/theme/utils/get_wishlist_theme.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/utils/wish_sort_utils.dart';
import 'package:wishlist/shared/widgets/dialogs/confirm_dialog.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({
    super.key,
    required this.wishlistId,
  });

  final int wishlistId;

  void _onAddWish(BuildContext context, Wishlist wishlist) {
    CreateWishRoute(wishlistId: wishlist.id).push(context);
  }

  void _onTapWish(
    BuildContext context,
    WidgetRef ref,
    Wish wish, {
    required bool isMyWishlist,
    required IList<Wish> wishsToDisplay,
  }) {
    final screenState =
        ref.read(wishlistScreenNotifierProvider(wishlistId));

    if (screenState.isSelectionMode) {
      ref
          .read(wishlistScreenNotifierProvider(wishlistId).notifier)
          .toggleWishSelection(wish.id);
      return;
    }

    final wishIds = wishsToDisplay.map((w) => w.id).toList();

    ConsultWishRoute(
      wish.wishlistId,
      wish.id,
      wishIds: wishIds,
      isMyWishlist: isMyWishlist,
    ).push(context);
  }

  Future<void> _onFavoriteToggle(
    BuildContext context,
    WidgetRef ref,
    Wish wish,
  ) async {
    try {
      final updatedWish = wish.copyWith(isFavourite: !wish.isFavourite);
      await ref.read(wishMutationsProvider.notifier).update(updatedWish);
    } catch (e) {
      if (context.mounted) {
        showGenericError(context, error: e);
      }
    }
  }

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

  Future<void> _refreshWishlistScreen(WidgetRef ref) async {
    ref.invalidate(wishlistScreenDataRealtimeProvider(wishlistId));
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _shareWishlist(BuildContext context, Wishlist wishlist) async {
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

  void _updateWishlistTheme(
    BuildContext context,
    WidgetRef ref,
    Wishlist wishlist,
  ) {
    final wishlistTheme = getWishlistTheme(context, wishlist);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(wishlistThemeCacheProvider(wishlist.id).notifier).state =
          wishlistTheme;
    });
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

        _updateWishlistTheme(context, ref, wishlist);

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
                    onShare: () =>
                        _shareWishlist(context, wishlist),
                    onSettings: () =>
                        showWishlistSettingsBottomSheet(
                      context,
                      wishlist,
                    ),
                  ),
                  body: SafeArea(
                    child: Stack(
                      children: [
                        _buildWishlistDetail(
                          context,
                          ref,
                          data,
                          screenState: screenState,
                          notifier: notifier,
                          isMyWishlist: isMyWishlist,
                        ),
                        if (isMyWishlist)
                          WishlistFloatingActions(
                            wishlistId: wishlistId,
                            wishlistTheme: wishlistTheme,
                            onAdd: () =>
                                _onAddWish(context, wishlist),
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

  Widget _buildWishlistDetail(
    BuildContext context,
    WidgetRef ref,
    WishlistScreenData wishlistScreenData, {
    required WishlistScreenState screenState,
    required WishlistScreenNotifier notifier,
    required bool isMyWishlist,
  }) {
    final wishlist = wishlistScreenData.wishlist;
    final wishs = WishSortUtils.sortAndFilterWishs(
      wishlistScreenData.wishs,
      wishSort: screenState.wishSort,
      searchQuery: screenState.searchQuery,
    );

    final isWishsBookedHidden = !wishlist.canOwnerSeeTakenWish && isMyWishlist;

    final wishsPending = isWishsBookedHidden
        ? wishs.toIList()
        : wishs.where((wish) => wish.availableQuantity > 0).toIList();

    final wishsBooked =
        wishs.where((wish) => wish.totalBookedQuantity > 0).toIList();

    final nbWishsPending = wishsPending.length;
    final nbWishsBooked = wishsBooked.length;

    void onTapWish(
      BuildContext context,
      Wish wish, {
      required bool isMyWishlist,
      required IList<Wish> wishsToDisplay,
      WishlistStatsCardType? cardType,
    }) {
      _onTapWish(
        context,
        ref,
        wish,
        isMyWishlist: isMyWishlist,
        wishsToDisplay: wishsToDisplay,
      );
    }

    WishlistContent buildContent({
      required IList<Wish> wishs,
      required bool shouldDisplay,
      required WishlistStatsCardType cardType,
    }) {
      return WishlistContent(
        wishlist: wishlist,
        wishsToDisplay: wishs,
        shouldDisplayWishs: shouldDisplay,
        statCardSelected: cardType,
        isWishsBookedHidden: isWishsBookedHidden,
        isMyWishlist: isMyWishlist,
        onTapWish: onTapWish,
        onAddWish: _onAddWish,
        onFavoriteToggle: (wish) =>
            _onFavoriteToggle(context, ref, wish),
        onRefresh: () => _refreshWishlistScreen(ref),
        isSelectionMode: screenState.isSelectionMode,
        selectedWishIds: screenState.selectedWishIds,
        onLongPressWish:
            isMyWishlist ? notifier.enableSelectionMode : null,
      );
    }

    return Column(
      children: [
        WishlistStatsSection(
          statCardSelected: screenState.statCardSelected,
          nbWishsTotal: wishs.length,
          nbWishsPending: nbWishsPending,
          nbWishsBooked: nbWishsBooked,
          isWishsBookedHidden: isWishsBookedHidden,
          onTapStatCard: notifier.selectStatCard,
        ),
        WishlistSearchBar(
          searchController: notifier.searchController,
          searchFocusNode: notifier.searchFocusNode,
          searchQuery: screenState.searchQuery,
          wishSort: screenState.wishSort,
          onSortChanged: notifier.updateSort,
          onClearFocus: () =>
              FocusScope.of(context).requestFocus(FocusNode()),
        ),
        Expanded(
          child: PageView(
            physics: const ClampingScrollPhysics(),
            controller: notifier.pageController,
            onPageChanged: notifier.onPageChanged,
            children: [
              buildContent(
                wishs: wishsPending,
                shouldDisplay: nbWishsPending > 0,
                cardType: WishlistStatsCardType.pending,
              ),
              buildContent(
                wishs: wishsBooked,
                shouldDisplay:
                    nbWishsBooked > 0 && !isWishsBookedHidden,
                cardType: WishlistStatsCardType.booked,
              ),
            ],
          ),
        ),
      ],
    );
  }

}
