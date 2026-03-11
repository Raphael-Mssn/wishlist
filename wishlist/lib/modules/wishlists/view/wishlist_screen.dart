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
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/utils/get_wishlist_theme.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/utils/wish_sort_utils.dart';
import 'package:wishlist/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:wishlist/shared/widgets/nav_bar_add_button.dart';

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
    final selectedIds =
        ref.read(wishlistScreenNotifierProvider(wishlistId)).selectedWishIds;
    final count = selectedIds.length;
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
          for (final wishId in selectedIds) {
            await ref.read(wishMutationsProvider.notifier).delete(wishId);
          }

          if (context.mounted) {
            notifier.exitSelectionMode();
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
    final selectedIds =
        ref.read(wishlistScreenNotifierProvider(wishlistId)).selectedWishIds;
    final count = selectedIds.length;
    final l10n = context.l10n;

    await showMoveWishesDialog(
      context,
      currentWishlistId: wishlistId,
      wishCount: count,
      onConfirm: (targetWishlistId) async {
        try {
          for (final wishId in selectedIds) {
            await ref.read(wishMutationsProvider.notifier).moveToWishlist(
                  wishId: wishId,
                  targetWishlistId: targetWishlistId,
                );
          }

          if (context.mounted) {
            notifier.exitSelectionMode();
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
                          _buildFloatingActionButtons(
                            context: context,
                            ref: ref,
                            screenState: screenState,
                            wishlistTheme: wishlistTheme,
                            wishlist: wishlist,
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
              WishlistContent(
                wishlist: wishlist,
                wishsToDisplay: wishsPending,
                shouldDisplayWishs: nbWishsPending > 0,
                statCardSelected: WishlistStatsCardType.pending,
                isWishsBookedHidden: isWishsBookedHidden,
                isMyWishlist: isMyWishlist,
                onTapWish: (
                  context,
                  wish, {
                  required isMyWishlist,
                  required wishsToDisplay,
                  cardType,
                }) =>
                    _onTapWish(
                      context,
                      ref,
                      wish,
                      isMyWishlist: isMyWishlist,
                      wishsToDisplay: wishsToDisplay,
                    ),
                onAddWish: _onAddWish,
                onFavoriteToggle: (wish) =>
                    _onFavoriteToggle(context, ref, wish),
                onRefresh: () => _refreshWishlistScreen(ref),
                isSelectionMode: screenState.isSelectionMode,
                selectedWishIds: screenState.selectedWishIds,
                onLongPressWish:
                    isMyWishlist ? notifier.enableSelectionMode : null,
              ),
              WishlistContent(
                wishlist: wishlist,
                wishsToDisplay: wishsBooked,
                shouldDisplayWishs:
                    nbWishsBooked > 0 && !isWishsBookedHidden,
                statCardSelected: WishlistStatsCardType.booked,
                isWishsBookedHidden: isWishsBookedHidden,
                isMyWishlist: isMyWishlist,
                onTapWish: (
                  context,
                  wish, {
                  required isMyWishlist,
                  required wishsToDisplay,
                  cardType,
                }) =>
                    _onTapWish(
                      context,
                      ref,
                      wish,
                      isMyWishlist: isMyWishlist,
                      wishsToDisplay: wishsToDisplay,
                    ),
                onAddWish: _onAddWish,
                onFavoriteToggle: (wish) =>
                    _onFavoriteToggle(context, ref, wish),
                onRefresh: () => _refreshWishlistScreen(ref),
                isSelectionMode: screenState.isSelectionMode,
                selectedWishIds: screenState.selectedWishIds,
                onLongPressWish:
                    isMyWishlist ? notifier.enableSelectionMode : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionBadge(int count) {
    return Positioned(
      top: -4,
      right: -4,
      child: Container(
        constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.darkGrey,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.background, width: 2),
        ),
        child: Center(
          child: Text(
            '$count',
            style: AppTextStyles.smaller.copyWith(
              color: AppColors.background,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    required Color colorDark,
    bool showBadge = false,
    int badgeCount = 0,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            primaryColor: color,
            primaryColorDark: colorDark,
          ),
          child: NavBarAddButton(icon: icon, onPressed: onPressed),
        ),
        if (showBadge) _buildSelectionBadge(badgeCount),
      ],
    );
  }

  Widget _buildFloatingActionButtons({
    required BuildContext context,
    required WidgetRef ref,
    required WishlistScreenState screenState,
    required ThemeData wishlistTheme,
    required Wishlist wishlist,
  }) {
    final isSelection = screenState.isSelectionMode;
    final badgeCount = screenState.selectedWishIds.length;

    return Positioned(
      bottom: 24,
      right: 24,
      child: SizedBox(
        height: 240,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              bottom: isSelection ? 80 : 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isSelection ? 1 : 0,
                child: IgnorePointer(
                  ignoring: !isSelection,
                  child: _buildActionButton(
                    context,
                    icon: Icons.drive_file_move,
                    onPressed: () => _moveSelectedWishs(context, ref),
                    color: wishlistTheme.primaryColor,
                    colorDark: wishlistTheme.primaryColorDark,
                    showBadge: isSelection,
                    badgeCount: badgeCount,
                  ),
                ),
              ),
            ),
            _buildActionButton(
              context,
              icon: isSelection ? Icons.delete : Icons.add,
              onPressed: isSelection
                  ? () => _deleteSelectedWishs(context, ref)
                  : () => _onAddWish(context, wishlist),
              color: isSelection ? Colors.red : wishlistTheme.primaryColor,
              colorDark: isSelection
                  ? AppColors.darken(Colors.red)
                  : wishlistTheme.primaryColorDark,
              showBadge: isSelection,
              badgeCount: badgeCount,
            ),
          ],
        ),
      ),
    );
  }
}
