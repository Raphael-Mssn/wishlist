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
import 'package:wishlist/shared/infra/wishs_from_wishlist_provider.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/models/wish/wish_sort_type.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/utils/get_wishlist_theme.dart';
import 'package:wishlist/shared/utils/scaffold_messenger_extension.dart';
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
  }) {
    if (isMyWishlist) {
      showEditWishBottomSheet(context, wish);
    } else {
      showConsultWishBottomSheet(context, wish);
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
        ScaffoldMessenger.of(context).showGenericError();
      }
    }
  }

  /// Nettoie l'historique de focus pour empêcher la restauration automatique
  void _clearFocusHistory() {
    FocusScope.of(context).unfocus();
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

  @override
  Widget build(BuildContext context) {
    final wishlistScreenData =
        ref.watch(wishlistScreenDataProvider(widget.wishlistId));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: wishlistScreenData.when(
          data: (data) {
            final wishlist = data.wishlist;
            final wishlistTheme = getWishlistTheme(context, wishlist);
            final isMyWishlist = wishlist.idOwner ==
                ref.read(userServiceProvider).getCurrentUserId();

            return Theme(
              data: wishlistTheme,
              child: AppBar(
                actions: [
                  if (isMyWishlist)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: IconButton(
                        icon: const Icon(
                          Icons.settings,
                          size: 32,
                        ),
                        onPressed: () => showWishlistSettingsBottomSheet(
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
            );
          },
          loading: AppBar.new,
          error: (_, __) => AppBar(),
        ),
      ),
      body: wishlistScreenData.when(
        data: (wishlistScreenData) {
          final wishlist = wishlistScreenData.wishlist;
          final wishlistTheme = getWishlistTheme(context, wishlist);
          final isMyWishlist = wishlist.idOwner ==
              ref.read(userServiceProvider).getCurrentUserId();

          return AnimatedTheme(
            data: wishlistTheme,
            child: Builder(
              builder: (context) {
                return Stack(
                  children: [
                    _buildWishlistDetail(
                      wishlistScreenData,
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
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => const SizedBox.shrink(),
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
        wishs.where((wish) => wish.takenByUser.isEmpty).toIList();
    final wishsBooked =
        wishs.where((wish) => wish.takenByUser.isNotEmpty).toIList();
    final isWishsBookedHidden = !wishlist.canOwnerSeeTakenWish && isMyWishlist;

    final wishsToDisplay = isWishsBookedHidden
        ? wishs
        : statCardSelected == WishlistStatsCardType.pending
            ? wishsPending
            : wishsBooked;

    final nbWishsPending =
        isWishsBookedHidden ? wishs.length : wishsPending.length;
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
