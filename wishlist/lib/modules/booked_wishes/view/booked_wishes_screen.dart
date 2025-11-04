import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/gen/assets.gen.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/booked_wishes/view/widgets/booked_wish_card.dart';
import 'package:wishlist/modules/booked_wishes/view/widgets/booked_wishes_search_bar.dart';
import 'package:wishlist/modules/booked_wishes/view/widgets/user_group_header.dart';
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

  void _onSortChanged(BookedWishSort sort) {
    setState(() {
      _sort = sort;
    });
  }

  void _clearFocusHistory() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  /// Filtre et groupe les wishes par utilisateur
  Map<String, List<BookedWishWithDetails>> _filterAndGroupWishes(
    List<BookedWishWithDetails> bookedWishes,
  ) {
    // Filtrer par recherche
    final filtered = bookedWishes.where((bookedWish) {
      if (_searchQuery.isEmpty) return true;

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
    const gap = 16.0;

    Future<void> refreshBookedWishes() async {
      await ref.read(bookedWishesProvider.notifier).loadBookedWishes();
    }

    return bookedWishesAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) {
        ScaffoldMessenger.of(context).showGenericError(isTopSnackBar: true);
        return const SizedBox.shrink();
      },
      data: (bookedWishes) {
        if (bookedWishes.isEmpty) {
          return PageLayoutEmpty(
            illustrationUrl: Assets.svg.noWishlist,
            title: l10n.bookedWishesEmptyTitle,
            onRefresh: refreshBookedWishes,
            appBarTitle: l10n.bookedWishesScreenTitle,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => SettingsRoute().push(context),
              ),
            ],
          );
        }

        final groupedWishes = _filterAndGroupWishes(bookedWishes.toList());

        // Si le filtrage ne retourne aucun résultat
        if (groupedWishes.isEmpty) {
          return PageLayout(
            title: l10n.bookedWishesScreenTitle,
            onRefresh: refreshBookedWishes,
            padding: EdgeInsets.zero,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => SettingsRoute().push(context),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.all(16).copyWith(bottom: 0),
              child: Column(
                children: [
                  BookedWishesSearchBar(
                    searchController: _searchController,
                    searchFocusNode: _searchFocusNode,
                    searchQuery: _searchQuery,
                    sort: _sort,
                    onSortChanged: _onSortChanged,
                    onClearFocus: _clearFocusHistory,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        l10n.noUserFound,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final containers = <Widget>[];
        var position = 0;

        for (final entry in groupedWishes.entries) {
          final ownerWishes = entry.value;
          final firstWish = ownerWishes.first;

          containers.add(
            AnimationConfiguration.staggeredList(
              position: position++,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50,
                child: FadeInAnimation(
                  child: Container(
                    padding: const EdgeInsets.all(16),
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
                        // User header
                        UserGroupHeader(
                          avatarUrl: firstWish.ownerAvatarUrl,
                          pseudo: firstWish.ownerPseudo,
                          wishCount: ownerWishes.length,
                        ),
                        const Gap(gap),
                        ...ownerWishes.map((bookedWish) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: BookedWishCard(
                              bookedWish: bookedWish,
                              onTap: () {
                                showConsultWishBottomSheet(
                                  context,
                                  bookedWish.wish,
                                );
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return PageLayout(
          title: l10n.bookedWishesScreenTitle,
          onRefresh: refreshBookedWishes,
          padding: EdgeInsets.zero,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => SettingsRoute().push(context),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.all(16).copyWith(bottom: 0),
            child: Column(
              spacing: gap,
              children: [
                BookedWishesSearchBar(
                  searchController: _searchController,
                  searchFocusNode: _searchFocusNode,
                  searchQuery: _searchQuery,
                  sort: _sort,
                  onSortChanged: _onSortChanged,
                  onClearFocus: _clearFocusHistory,
                ),
                Expanded(
                  child: AnimationLimiter(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: 120),
                      itemCount: containers.length,
                      separatorBuilder: (context, index) => const Gap(gap),
                      itemBuilder: (context, index) => containers[index],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
