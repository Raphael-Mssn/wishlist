import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishlists/infra/wishlist_screen_data_realtime_provider.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_content.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_search_bar.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_settings_bottom_sheet.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_card.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_section.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/infra/wish_mutations_provider.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/models/wish/wish_sort_type.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/providers/wishlist_theme_provider.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/utils/get_wishlist_theme.dart';
import 'package:wishlist/shared/theme/widgets/app_wave_pattern.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/utils/string_utils.dart';
import 'package:wishlist/shared/utils/wish_sort_utils.dart';
import 'package:wishlist/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:wishlist/shared/widgets/nav_bar_add_button.dart';

class WishlistScreen extends ConsumerStatefulWidget {
  const WishlistScreen({
    super.key,
    required this.wishlistId,
  });

  final int wishlistId;

  @override
  ConsumerState<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends ConsumerState<WishlistScreen> {
  static const double _appBarBorderRadius = 32;

  WishlistStatsCardType statCardSelected = WishlistStatsCardType.pending;
  WishSort wishSort = const WishSort(
    type: WishSortType.favorite,
    order: SortOrder.descending,
  );

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  late final PageController _pageController;

  bool _isSelectionMode = false;
  final Set<int> _selectedWishIds = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: statCardSelected.index,
    );
    _searchController.addListener(() {
      setState(() {
        _searchQuery = normalizeString(_searchController.text);
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _enableSelectionMode(int wishId) {
    setState(() {
      _isSelectionMode = true;
      _selectedWishIds.add(wishId);
    });
  }

  void _toggleWishSelection(int wishId) {
    setState(() {
      if (_selectedWishIds.contains(wishId)) {
        _selectedWishIds.remove(wishId);
        if (_selectedWishIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedWishIds.add(wishId);
      }
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedWishIds.clear();
    });
  }

  Future<void> _deleteSelectedWishs(BuildContext context) async {
    final count = _selectedWishIds.length;
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
          for (final wishId in _selectedWishIds) {
            await ref.read(wishMutationsProvider.notifier).delete(wishId);
          }

          if (context.mounted) {
            _exitSelectionMode();
            showAppSnackBar(
              context,
              count == 1 ? l10n.deleteWishSuccess : l10n.wishesDeleted(count),
              type: SnackBarType.success,
            );
          }
        } catch (e) {
          if (context.mounted) {
            showGenericError(context);
          }
        }
      },
    );
  }

  void onAddWish(BuildContext context, Wishlist wishlist) {
    CreateWishRoute(wishlistId: wishlist.id).push(context);
  }

  void onTapWish(
    BuildContext context,
    Wish wish, {
    required bool isMyWishlist,
    required IList<Wish> wishsToDisplay,
    WishlistStatsCardType? cardType,
  }) {
    // Si en mode sélection, toggle la sélection au lieu de naviguer
    if (_isSelectionMode) {
      _toggleWishSelection(wish.id);
      return;
    }

    final wishIds = wishsToDisplay.map((wish) => wish.id).toList();

    ConsultWishRoute(
      wish.wishlistId,
      wish.id,
      wishIds: wishIds,
      isMyWishlist: isMyWishlist,
    ).push(context);
  }

  void onTapStatCard(WishlistStatsCardType type) {
    setState(() {
      statCardSelected = type;
    });
    _pageController.animateToPage(
      type.index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onSortChanged(WishSort sort) {
    setState(() {
      wishSort = sort;
    });
  }

  Future<void> onFavoriteToggle(Wish wish) async {
    try {
      final updatedWish = wish.copyWith(
        isFavourite: !wish.isFavourite,
      );

      await ref.read(wishMutationsProvider.notifier).update(updatedWish);
    } catch (e) {
      if (mounted) {
        showGenericError(context);
      }
    }
  }

  /// Nettoie l'historique de focus pour empêcher la restauration automatique
  void _clearFocusHistory() {
    // Forcer la perte de l'historique de focus
    FocusScope.of(context).requestFocus(FocusNode());
  }

  IList<Wish> _sortAndFilterWishs(IList<Wish> wishs) {
    return WishSortUtils.sortAndFilterWishs(
      wishs,
      wishSort: wishSort,
      searchQuery: _searchQuery,
    );
  }

  Widget _buildSelectionBadge() {
    return Positioned(
      top: -4,
      right: -4,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 28,
          minHeight: 28,
        ),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.darkGrey,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.background,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            '${_selectedWishIds.length}',
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

  Future<void> refreshWishlistScreen() async {
    ref.invalidate(wishlistScreenDataRealtimeProvider(widget.wishlistId));

    // Attendre un peu pour voir le feedback visuel du RefreshIndicator
    await Future.delayed(const Duration(milliseconds: 300));
  }

  void _updateWishlistTheme(WidgetRef ref, Wishlist wishlist) {
    final wishlistTheme = getWishlistTheme(context, wishlist);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(wishlistThemeCacheProvider(wishlist.id).notifier).state =
          wishlistTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wishlistScreenData =
        ref.watch(wishlistScreenDataRealtimeProvider(widget.wishlistId));

    return wishlistScreenData.when(
      data: (data) {
        final wishlist = data.wishlist;
        final wishlistTheme = getWishlistTheme(context, wishlist);
        final isMyWishlist = wishlist.idOwner ==
            ref.read(userServiceProvider).getCurrentUserId();

        _updateWishlistTheme(ref, wishlist);

        return AnimatedTheme(
          data: wishlistTheme,
          child: Builder(
            builder: (context) {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(70),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(_appBarBorderRadius),
                    ),
                    child: AppWavePattern(
                      backgroundColor: wishlistTheme.primaryColor,
                      preset: WavePreset.appBar,
                      rotationType: WaveRotationType.fixed,
                      rotationAngle: 45,
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        actions: [
                          if (isMyWishlist)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.settings,
                                  size: 32,
                                ),
                                onPressed: () =>
                                    showWishlistSettingsBottomSheet(
                                  context,
                                  wishlist,
                                ),
                              ),
                            ),
                        ],
                        foregroundColor: AppColors.background,
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            wishlist.name,
                            style: AppTextStyles.medium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        centerTitle: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(_appBarBorderRadius),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                body: Stack(
                  children: [
                    _buildWishlistDetail(
                      data,
                      context,
                      ref,
                      isMyWishlist: isMyWishlist,
                    ),
                    if (isMyWishlist)
                      Positioned(
                        bottom: 24,
                        right: 24,
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                              child: _isSelectionMode
                                  ? Stack(
                                      key: const ValueKey('delete'),
                                      clipBehavior: Clip.none,
                                      children: [
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            primaryColor: Colors.red,
                                            primaryColorDark:
                                                AppColors.darken(Colors.red),
                                          ),
                                          child: NavBarAddButton(
                                            icon: Icons.delete,
                                            onPressed: () =>
                                                _deleteSelectedWishs(context),
                                          ),
                                        ),
                                        _buildSelectionBadge(),
                                      ],
                                    )
                                  : NavBarAddButton(
                                      key: const ValueKey('add'),
                                      icon: Icons.add,
                                      onPressed: () =>
                                          onAddWish(context, wishlist),
                                    ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
        ),
        body: const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildWishlistDetail(
    WishlistScreenData wishlistScreenData,
    BuildContext context,
    WidgetRef ref, {
    required bool isMyWishlist,
  }) {
    // On sait que wishlist n'est pas null car on a déjà vérifié dans build()
    final wishlist = wishlistScreenData.wishlist;
    final wishs = _sortAndFilterWishs(wishlistScreenData.wishs);

    final isWishsBookedHidden = !wishlist.canOwnerSeeTakenWish && isMyWishlist;

    // Si les wishs réservés sont cachés pour le propriétaire,
    // alors afficher tous les wishs en "pending"
    final wishsPending = isWishsBookedHidden
        ? wishs.toIList()
        : wishs.where((wish) => wish.availableQuantity > 0).toIList();

    final wishsBooked =
        wishs.where((wish) => wish.totalBookedQuantity > 0).toIList();

    final nbWishsPending = wishsPending.length;
    final nbWishsBooked = wishsBooked.length;

    final hasWishsPending = nbWishsPending > 0;
    final hasWishsBooked = nbWishsBooked > 0;

    return Column(
      children: [
        WishlistStatsSection(
          statCardSelected: statCardSelected,
          nbWishsTotal: wishs.length,
          nbWishsPending: nbWishsPending,
          nbWishsBooked: nbWishsBooked,
          isWishsBookedHidden: isWishsBookedHidden,
          onTapStatCard: onTapStatCard,
        ),
        WishlistSearchBar(
          searchController: _searchController,
          searchFocusNode: _searchFocusNode,
          searchQuery: _searchQuery,
          wishSort: wishSort,
          onSortChanged: onSortChanged,
          onClearFocus: _clearFocusHistory,
        ),
        Expanded(
          child: PageView(
            physics: const ClampingScrollPhysics(),
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                statCardSelected = WishlistStatsCardType.values[index];
              });
            },
            children: [
              WishlistContent(
                wishlist: wishlist,
                wishsToDisplay: wishsPending,
                shouldDisplayWishs: hasWishsPending,
                statCardSelected: WishlistStatsCardType.pending,
                isWishsBookedHidden: isWishsBookedHidden,
                isMyWishlist: isMyWishlist,
                onTapWish: onTapWish,
                onAddWish: onAddWish,
                onFavoriteToggle: onFavoriteToggle,
                onRefresh: refreshWishlistScreen,
                isSelectionMode: _isSelectionMode,
                selectedWishIds: _selectedWishIds,
                onLongPressWish: isMyWishlist ? _enableSelectionMode : null,
              ),
              WishlistContent(
                wishlist: wishlist,
                wishsToDisplay: wishsBooked,
                shouldDisplayWishs: hasWishsBooked && !isWishsBookedHidden,
                statCardSelected: WishlistStatsCardType.booked,
                isWishsBookedHidden: isWishsBookedHidden,
                isMyWishlist: isMyWishlist,
                onTapWish: onTapWish,
                onAddWish: onAddWish,
                onFavoriteToggle: onFavoriteToggle,
                onRefresh: refreshWishlistScreen,
                isSelectionMode: _isSelectionMode,
                selectedWishIds: _selectedWishIds,
                onLongPressWish: isMyWishlist ? _enableSelectionMode : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
