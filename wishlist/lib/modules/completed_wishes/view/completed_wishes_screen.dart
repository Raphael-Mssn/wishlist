import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/completed_wishes/view/widgets/completed_wish_sort_bottom_sheet.dart';
import 'package:wishlist/modules/completed_wishes/view/widgets/uncomplete_wish_bottom_sheet.dart';
import 'package:wishlist/modules/wishs/view/screens/consult_wish_screen.dart';
import 'package:wishlist/shared/infra/completed_wishes_realtime_provider.dart';
import 'package:wishlist/shared/models/completed_wish_sort_type.dart';
import 'package:wishlist/shared/models/completed_wish_with_details/completed_wish_with_details.dart';
import 'package:wishlist/shared/models/wish/wish_sort_type.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/pill.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/utils/string_utils.dart';
import 'package:wishlist/shared/widgets/animated_list_view.dart';
import 'package:wishlist/shared/widgets/page_layout.dart';
import 'package:wishlist/shared/widgets/search_bar/app_search_bar.dart';
import 'package:wishlist/shared/widgets/wish_image.dart';

class CompletedWishesScreen extends ConsumerStatefulWidget {
  const CompletedWishesScreen({super.key});

  @override
  ConsumerState<CompletedWishesScreen> createState() =>
      _CompletedWishesScreenState();
}

class _CompletedWishesScreenState extends ConsumerState<CompletedWishesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  CompletedWishSort _sort = const CompletedWishSort(
    type: CompletedWishSortType.completedAt,
    order: SortOrder.descending,
  );

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
    final normalized = normalizeString(_searchController.text);
    if (_searchQuery != normalized) {
      setState(() => _searchQuery = normalized);
    }
  }

  void _clearFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  List<CompletedWishWithDetails> _filterAndSort(
    List<CompletedWishWithDetails> items,
  ) {
    var result = items;
    if (_searchQuery.isNotEmpty) {
      result = result.where((item) {
        return normalizeString(item.wish.name).contains(_searchQuery) ||
            normalizeString(item.fromWishlistName).contains(_searchQuery);
      }).toList();
    }
    result = List.of(result);
    switch (_sort.type) {
      case CompletedWishSortType.alphabetical:
        result.sort((a, b) {
          final cmp =
              a.wish.name.toLowerCase().compareTo(b.wish.name.toLowerCase());
          return _sort.order == SortOrder.ascending ? cmp : -cmp;
        });
      case CompletedWishSortType.completedAt:
        result.sort((a, b) {
          final cmp = a.completedAt.compareTo(b.completedAt);
          return _sort.order == SortOrder.ascending ? cmp : -cmp;
        });
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final completedWishesAsync = ref.watch(completedWishesRealtimeProvider);

    return PageLayout(
      title: l10n.completedWishesScreenTitle,
      padding: EdgeInsets.zero,
      child: completedWishesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              showGenericError(context, error: error);
            }
          });
          return const SizedBox.shrink();
        },
        data: (completedWishes) {
          if (completedWishes.isEmpty) {
            return Center(
              child: Text(
                l10n.completedWishesEmptyTitle,
                style: AppTextStyles.small.copyWith(color: AppColors.makara),
              ),
            );
          }

          final filtered = _filterAndSort(completedWishes.toList());

          return Column(
            children: [
              _SearchBar(
                searchController: _searchController,
                searchFocusNode: _searchFocusNode,
                searchQuery: _searchQuery,
                sort: _sort,
                onSortChanged: (newSort) => setState(() => _sort = newSort),
                onClearFocus: _clearFocus,
              ),
              Expanded(
                child: ColoredBox(
                  color: AppColors.gainsboro,
                  child: filtered.isEmpty
                      ? Center(
                          child: Text(
                            l10n.completedWishesEmptyTitle,
                            style: AppTextStyles.small
                                .copyWith(color: AppColors.makara),
                          ),
                        )
                      : AnimatedListView<CompletedWishWithDetails>(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                          items: filtered,
                          animationDuration: const Duration(milliseconds: 500),
                          itemSpacing: 12,
                          itemEquality: (oldItem, newItem) =>
                              oldItem.wish.id == newItem.wish.id,
                          itemBuilder: (context, item, index) {
                            return _CompletedWishCard(item: item);
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.searchController,
    required this.searchFocusNode,
    required this.searchQuery,
    required this.sort,
    required this.onSortChanged,
    required this.onClearFocus,
  });

  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final String searchQuery;
  final CompletedWishSort sort;
  final Function(CompletedWishSort) onSortChanged;
  final VoidCallback onClearFocus;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: AppColors.gainsboro,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SearchField(
              searchController: searchController,
              searchFocusNode: searchFocusNode,
              searchQuery: searchQuery,
              hintText: context.l10n.wishlistSearchHint,
              onClearFocus: onClearFocus,
            ),
          ),
          const Gap(12),
          SearchBarButton(
            icon: Icons.sort,
            smallIcon: sort.type.icon,
            onTap: () {
              showCompletedWishSortBottomSheet(
                context,
                currentSort: sort,
                onSortChanged: onSortChanged,
              );
            },
          ),
          const Gap(8),
          SearchBarButton(
            icon: sort.icon,
            onTap: () {
              final newSort = sort.toggleOrder();
              onSortChanged(newSort);
            },
          ),
        ],
      ),
    );
  }
}

class _CompletedWishCard extends StatelessWidget {
  const _CompletedWishCard({required this.item});

  final CompletedWishWithDetails item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final wish = item.wish;

    return Card(
      color: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: () => ConsultWishRoute(
          wish.wishlistId,
          wish.id,
          wishIds: [wish.id],
          showActions: false,
          quantityDisplay: WishQuantityDisplay.completed,
        ).push(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  WishImage(
                    iconUrl: wish.iconUrl,
                    size: 56,
                    borderRadius: 12,
                  ),
                  if (item.quantity > 1)
                    Positioned(
                      bottom: -4,
                      right: -4,
                      child: Pill(
                        text: 'x${item.quantity}',
                        backgroundColor: Theme.of(context).primaryColor,
                        textStyle: AppTextStyles.smaller,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                    ),
                ],
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wish.name,
                      style: AppTextStyles.small.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(2),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.fromWishlistName,
                            style: AppTextStyles.smaller.copyWith(
                              color: AppColors.makara,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          DateFormat.yMMMMd(
                            Localizations.localeOf(context).toString(),
                          ).format(item.completedAt.toLocal()),
                          style: AppTextStyles.smaller.copyWith(
                            color: AppColors.makara,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(8),
              IconButton(
                icon: const Icon(Icons.undo, color: AppColors.makara),
                tooltip: l10n.unmarkWishAsCompleted,
                onPressed: () => showUncompleteWishBottomSheet(context, item),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
