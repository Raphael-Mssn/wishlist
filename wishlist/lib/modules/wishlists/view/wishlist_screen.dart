import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/modules/wishlists/infra/wishlist_screen_data_provider.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_content.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_search_bar.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_settings_bottom_sheet.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_card.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_section.dart';
import 'package:wishlist/modules/wishs/view/widgets/consult_wish_bottom_sheet.dart';
import 'package:wishlist/modules/wishs/view/widgets/create_wish_bottom_sheet.dart';
import 'package:wishlist/modules/wishs/view/widgets/edit_wish_bottom_sheet.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/infra/wishlist_by_id_provider.dart';
import 'package:wishlist/shared/infra/wishs_from_wishlist_provider.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/models/wish/wish_sort_type.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/utils/get_wishlist_theme.dart';
import 'package:wishlist/shared/theme/widgets/app_wave_pattern.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/utils/wish_sort_utils.dart';
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

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    // Rafraîchir les données de la wishlist à l'ouverture
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshWishlistData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void onAddWish(BuildContext context, Wishlist wishlist) {
    showCreateWishBottomSheet(context, wishlist);
  }

  void onTapWish(
    BuildContext context,
    Wish wish, {
    required bool isMyWishlist,
    WishlistStatsCardType? cardType,
  }) {
    if (isMyWishlist) {
      showEditWishBottomSheet(context, wish);
    } else {
      showConsultWishBottomSheet(context, wish, cardType: cardType);
    }
  }

  void onTapStatCard(WishlistStatsCardType type) {
    setState(() {
      statCardSelected = type;
    });
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

      await ref
          .read(wishsFromWishlistProvider(widget.wishlistId).notifier)
          .updateWish(updatedWish);
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

  /// Rafraîchit les données de la wishlist (wishlist et wishs)
  Future<void> _refreshWishlistData() async {
    // Rafraîchir les wishs
    await ref
        .read(wishsFromWishlistProvider(widget.wishlistId).notifier)
        .loadWishs();

    // Rafraîchir les données de la wishlist
    ref.invalidate(wishlistByIdProvider(widget.wishlistId));
  }

  IList<Wish> _sortAndFilterWishs(IList<Wish> wishs) {
    return WishSortUtils.sortAndFilterWishs(
      wishs,
      wishSort: wishSort,
      searchQuery: _searchQuery,
    );
  }

  @override
  Widget build(BuildContext context) {
    final wishlistScreenData =
        ref.watch(wishlistScreenDataProvider(widget.wishlistId));

    return wishlistScreenData.when(
      data: (data) {
        final wishlist = data.wishlist;
        final wishlistTheme = getWishlistTheme(context, wishlist);
        final isMyWishlist = wishlist.idOwner ==
            ref.read(userServiceProvider).getCurrentUserId();

        // Appliquer le thème de la wishlist à tout l'écran
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
                            child: NavBarAddButton(
                              icon: Icons.add,
                              onPressed: () => onAddWish(context, wishlist),
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
    final wishlist = wishlistScreenData.wishlist;
    final wishs = _sortAndFilterWishs(wishlistScreenData.wishs);

    final wishsPending =
        wishs.where((wish) => wish.availableQuantity > 0).toIList();
    final wishsBooked =
        wishs.where((wish) => wish.totalBookedQuantity > 0).toIList();
    final isWishsBookedHidden = !wishlist.canOwnerSeeTakenWish && isMyWishlist;

    final wishsToDisplay = isWishsBookedHidden
        ? wishs
        : statCardSelected == WishlistStatsCardType.pending
            ? wishsPending
            : wishsBooked;

    final nbWishsPending = wishsPending.length;
    final nbWishsBooked = wishsBooked.length;

    final hasWishsPending = nbWishsPending > 0;
    final hasWishsBooked = nbWishsBooked > 0;

    final shouldDisplayWishs =
        hasWishsPending && statCardSelected == WishlistStatsCardType.pending ||
            hasWishsBooked &&
                !isWishsBookedHidden &&
                statCardSelected == WishlistStatsCardType.booked;

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
        WishlistContent(
          wishlist: wishlist,
          wishsToDisplay: wishsToDisplay,
          shouldDisplayWishs: shouldDisplayWishs,
          statCardSelected: statCardSelected,
          isWishsBookedHidden: isWishsBookedHidden,
          isMyWishlist: isMyWishlist,
          onTapWish: onTapWish,
          onAddWish: onAddWish,
          onFavoriteToggle: onFavoriteToggle,
        ),
      ],
    );
  }
}
