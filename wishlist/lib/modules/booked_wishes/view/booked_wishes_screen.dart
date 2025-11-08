import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';
import 'package:wishlist/gen/assets.gen.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/booked_wishes/view/widgets/booked_wish_card.dart';
import 'package:wishlist/modules/booked_wishes/view/widgets/booked_wishes_search_bar.dart';
import 'package:wishlist/modules/booked_wishes/view/widgets/booked_wishes_stats.dart';
import 'package:wishlist/modules/booked_wishes/view/widgets/user_group_header.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_card.dart';
import 'package:wishlist/modules/wishs/view/widgets/consult_wish_bottom_sheet.dart';
import 'package:wishlist/shared/infra/booked_wishes_realtime_provider.dart';
import 'package:wishlist/shared/models/booked_wish_sort_type.dart';
import 'package:wishlist/shared/models/booked_wish_with_details/booked_wish_with_details.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/page_layout_empty/page_layout_empty.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/utils/booked_wish_sort_utils.dart';
import 'package:wishlist/shared/utils/scaffold_messenger_extension.dart';
import 'package:wishlist/shared/utils/string_utils.dart';
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
  static const int _staggeredAnimationDelay = 20;
  static const int _staggeredAnimationMargin = 200;

  BookedWishSort _sort = const BookedWishSort(
    type: BookedWishSortType.alphabetical,
    order: SortOrder.ascending,
  );

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _scheduleInitialLoadCompletion();
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _scheduleInitialLoadCompletion() {
    // Calculer la durée totale basée sur le nombre potentiel d'éléments
    // On estime un maximum raisonnable pour éviter d'attendre trop longtemps
    const estimatedMaxItems = 10;
    const totalDuration = _animationDurationMs +
        (estimatedMaxItems * _staggeredAnimationDelay) +
        _staggeredAnimationMargin;

    Future.delayed(const Duration(milliseconds: totalDuration), () {
      if (mounted) {
        setState(() => _isInitialLoad = false);
      }
    });
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = normalizeString(_searchController.text);
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
    ref.invalidate(bookedWishesRealtimeProvider);
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
    return BookedWishSortUtils.filterAndGroupWishes(
      bookedWishes,
      sort: _sort,
      searchQuery: _searchQuery,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bookedWishesAsync = ref.watch(bookedWishesRealtimeProvider);

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
                        ref.watch(bookedWishesRealtimeProvider).value ?? [],
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
              child: _isInitialLoad
                  ? _buildStaggeredListView(groupedWishes)
                  : _buildImplicitlyAnimatedList(groupedWishes),
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
                        ref.watch(bookedWishesRealtimeProvider).value ?? [],
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

  Widget _buildStaggeredUserGroup(
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
          child: _buildUserGroupCard(ownerWishes, firstWish),
        ),
      ),
    );
  }

  Widget _buildUserGroupCard(
    List<BookedWishWithDetails> ownerWishes,
    BookedWishWithDetails firstWish,
  ) {
    return Container(
      padding: const EdgeInsets.all(_contentPadding),
      decoration: BoxDecoration(
        color: AppColors.gainsboro,
        borderRadius: BorderRadius.circular(24),
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
          Column(
            spacing: 8,
            children: ownerWishes.map((bookedWish) {
              return BookedWishCard(
                bookedWish: bookedWish,
                onTap: () => _onWishTap(bookedWish),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStaggeredListView(
    Map<String, List<BookedWishWithDetails>> groupedWishes,
  ) {
    return AnimationLimiter(
      child: ListView.separated(
        padding: const EdgeInsets.only(
          top: 140,
          bottom: _listBottomPadding,
        ),
        itemCount: groupedWishes.length,
        separatorBuilder: (context, index) => const Gap(_itemSpacing),
        itemBuilder: (context, index) {
          final entry = groupedWishes.entries.elementAt(index);
          return _buildStaggeredUserGroup(entry.value, index);
        },
      ),
    );
  }

  Widget _buildImplicitlyAnimatedList(
    Map<String, List<BookedWishWithDetails>> groupedWishes,
  ) {
    // Convertir la Map en List pour ImplicitlyAnimatedList
    final groupsList =
        groupedWishes.entries.map((entry) => entry.value).toList();

    return ImplicitlyAnimatedList<List<BookedWishWithDetails>>(
      padding: const EdgeInsets.only(
        top: 140,
        bottom: _listBottomPadding,
      ),
      itemData: groupsList,
      itemEquality: (oldItem, newItem) {
        // Comparer par l'ID du propriétaire (premier wish du groupe)
        return oldItem.isNotEmpty &&
            newItem.isNotEmpty &&
            oldItem.first.ownerId == newItem.first.ownerId;
      },
      initialAnimation: false,
      itemBuilder: (context, ownerWishes) {
        if (ownerWishes.isEmpty) {
          return const SizedBox.shrink();
        }
        final firstWish = ownerWishes.first;
        final index = groupsList.indexOf(ownerWishes);

        return Padding(
          padding: EdgeInsets.only(
            bottom: index < groupsList.length - 1 ? _itemSpacing : 0,
          ),
          child: _buildUserGroupCard(ownerWishes, firstWish),
        );
      },
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
