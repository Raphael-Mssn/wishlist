import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/gen/assets.gen.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/booked_wishes/view/widgets/booked_wish_card.dart';
import 'package:wishlist/modules/booked_wishes/view/widgets/booked_wishes_search_bar.dart';
import 'package:wishlist/modules/booked_wishes/view/widgets/booked_wishes_stats.dart';
import 'package:wishlist/modules/booked_wishes/view/widgets/user_group_header.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_card.dart';
import 'package:wishlist/modules/wishs/view/widgets/consult_wish_bottom_sheet.dart';
import 'package:wishlist/shared/infra/booked_wishes_provider.dart';
import 'package:wishlist/shared/models/booked_wish_sort_type.dart';
import 'package:wishlist/shared/models/booked_wish_with_details/booked_wish_with_details.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/page_layout_empty/page_layout_empty.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/utils/scaffold_messenger_extension.dart';
import 'package:wishlist/shared/widgets/page_layout.dart';

class BookedWishesScreen extends ConsumerStatefulWidget {
  const BookedWishesScreen({super.key});

  @override
  ConsumerState<BookedWishesScreen> createState() => _BookedWishesScreenState();
}

class _BookedWishesScreenState extends ConsumerState<BookedWishesScreen> {
  static const double _contentPadding = 16;
  static const double _itemSpacing = 16;
  static const double _listBottomPadding = 110;
  static const int _animationDurationMs = 375;

  BookedWishSort _sort = const BookedWishSort(
    type: BookedWishSortType.alphabetical,
    order: SortOrder.ascending,
  );

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  void _onSortChanged(BookedWishSort sort) {
    setState(() {
      _sort = sort;
    });
  }

  void _clearFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<void> _refreshBookedWishes() async {
    await ref.read(bookedWishesProvider.notifier).loadBookedWishes();
  }

  List<Widget> _buildSettingsAction() {
    return [
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () => SettingsRoute().push(context),
      ),
    ];
  }

  /// Filtre et groupe les wishes par utilisateur
  Map<String, List<BookedWishWithDetails>> _filterAndGroupWishes(
    List<BookedWishWithDetails> bookedWishes,
  ) {
    // Filtrer par recherche
    final filtered = bookedWishes.where((bookedWish) {
      if (_searchQuery.isEmpty) {
        return true;
      }

      final wishName = bookedWish.wish.name.toLowerCase();
      final ownerPseudo = bookedWish.ownerPseudo.toLowerCase();

      return wishName.contains(_searchQuery) ||
          ownerPseudo.contains(_searchQuery);
    }).toList();

    // Grouper par utilisateur
    final grouped = <String, List<BookedWishWithDetails>>{};
    for (final bookedWish in filtered) {
      grouped.putIfAbsent(bookedWish.ownerId, () => []).add(bookedWish);
    }

    // Trier les groupes
    final sortedEntries = grouped.entries.toList();

    switch (_sort.type) {
      case BookedWishSortType.alphabetical:
        sortedEntries.sort((a, b) {
          final pseudo1 = a.value.first.ownerPseudo.toLowerCase();
          final pseudo2 = b.value.first.ownerPseudo.toLowerCase();
          return _sort.order == SortOrder.ascending
              ? pseudo1.compareTo(pseudo2)
              : pseudo2.compareTo(pseudo1);
        });
      case BookedWishSortType.bookingCount:
        sortedEntries.sort((a, b) {
          final count1 = a.value.length;
          final count2 = b.value.length;
          return _sort.order == SortOrder.ascending
              ? count1.compareTo(count2)
              : count2.compareTo(count1);
        });
    }

    return Map.fromEntries(sortedEntries);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bookedWishesAsync = ref.watch(bookedWishesProvider);

    return bookedWishesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        ScaffoldMessenger.of(context).showGenericError(isTopSnackBar: true);
        return const SizedBox.shrink();
      },
      data: (bookedWishes) {
        if (bookedWishes.isEmpty) {
          return _buildEmptyState(l10n);
        }

        final groupedWishes = _filterAndGroupWishes(bookedWishes.toList());

        if (groupedWishes.isEmpty) {
          return _buildEmptySearchResults(l10n);
        }

        return _buildContent(l10n, groupedWishes);
      },
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return PageLayoutEmpty(
      illustrationUrl: Assets.svg.noWishlist,
      title: l10n.bookedWishesEmptyTitle,
      onRefresh: _refreshBookedWishes,
      appBarTitle: l10n.bookedWishesScreenTitle,
      actions: _buildSettingsAction(),
    );
  }

  Widget _buildEmptySearchResults(AppLocalizations l10n) {
    return PageLayout(
      title: l10n.bookedWishesScreenTitle,
      onRefresh: _refreshBookedWishes,
      padding: EdgeInsets.zero,
      actions: _buildSettingsAction(),
      child: Stack(
        children: [
          // Centre avec message "aucun résultat"
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(top: 110),
              child: Center(
                child: Text(
                  l10n.wishlistNoWishBooked,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          // Header fixe avec stats + searchbar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background,
                    AppColors.background,
                    AppColors.background.withValues(alpha: 0.95),
                    AppColors.background.withValues(alpha: 0),
                  ],
                  stops: const [0.0, 0.7, 0.9, 1.0],
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.all(_contentPadding).copyWith(bottom: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: _itemSpacing,
                  children: [
                    BookedWishesStats(
                      bookedWishes: List<BookedWishWithDetails>.from(
                        ref.watch(bookedWishesProvider).value ?? [],
                      ),
                    ),
                    _buildSearchBar(l10n),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    AppLocalizations l10n,
    Map<String, List<BookedWishWithDetails>> groupedWishes,
  ) {
    return PageLayout(
      title: l10n.bookedWishesScreenTitle,
      onRefresh: _refreshBookedWishes,
      padding: EdgeInsets.zero,
      actions: _buildSettingsAction(),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: _contentPadding),
              child: AnimationLimiter(
                child: ListView.separated(
                  // Padding pour éviter que le premier élément soit
                  // sous la searchbar
                  padding: const EdgeInsets.only(
                    top: 140,
                    bottom: _listBottomPadding,
                  ),
                  itemCount: groupedWishes.length,
                  separatorBuilder: (context, index) => const Gap(_itemSpacing),
                  itemBuilder: (context, index) {
                    final entry = groupedWishes.entries.elementAt(index);
                    return _buildUserGroup(entry.value, index);
                  },
                ),
              ),
            ),
          ),
          // Header fixe avec stats + searchbar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background,
                    AppColors.background,
                    AppColors.background.withValues(alpha: 0.95),
                    AppColors.background.withValues(alpha: 0),
                  ],
                  stops: const [0.0, 0.7, 0.9, 1.0],
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.all(_contentPadding).copyWith(bottom: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: _itemSpacing,
                  children: [
                    BookedWishesStats(
                      bookedWishes: List<BookedWishWithDetails>.from(
                        ref.watch(bookedWishesProvider).value ?? [],
                      ),
                    ),
                    _buildSearchBar(l10n),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations l10n) {
    return BookedWishesSearchBar(
      searchController: _searchController,
      searchFocusNode: _searchFocusNode,
      searchQuery: _searchQuery,
      sort: _sort,
      onSortChanged: _onSortChanged,
      onClearFocus: _clearFocus,
    );
  }

  Widget _buildUserGroup(
    List<BookedWishWithDetails> ownerWishes,
    int position,
  ) {
    final firstWish = ownerWishes.first;

    return AnimationConfiguration.staggeredList(
      position: position,
      duration: const Duration(milliseconds: _animationDurationMs),
      child: SlideAnimation(
        verticalOffset: 50,
        child: FadeInAnimation(
          child: Container(
            padding: const EdgeInsets.all(_contentPadding),
            decoration: BoxDecoration(
              color: AppColors.gainsboro,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserGroupHeader(
                  avatarUrl: firstWish.ownerAvatarUrl,
                  pseudo: firstWish.ownerPseudo,
                  wishCount: ownerWishes.length,
                  onTap: () => _onUserTap(firstWish.ownerId),
                ),
                const Gap(_itemSpacing),
                ...ownerWishes.map((bookedWish) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: BookedWishCard(
                      bookedWish: bookedWish,
                      onTap: () => _onWishTap(bookedWish),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onWishTap(BookedWishWithDetails bookedWish) {
    showConsultWishBottomSheet(
      context,
      bookedWish.wish,
      cardType: WishlistStatsCardType.booked,
      onWishUpdated: _refreshBookedWishes,
    );
  }

  void _onUserTap(String userId) {
    FriendDetailsRoute(userId).push(context);
  }
}
