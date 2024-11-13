import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/gen/assets.gen.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishlists/infra/wishlist_screen_data_provider.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wish_card.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_settings_bottom_sheet.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_card.dart';
import 'package:wishlist/modules/wishs/view/widgets/consult_wish_bottom_sheet.dart';
import 'package:wishlist/modules/wishs/view/widgets/create_wish_bottom_sheet.dart';
import 'package:wishlist/modules/wishs/view/widgets/edit_wish_bottom_sheet.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/infra/wishs_from_wishlist_provider.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/page_layout_empty/page_layout_empty_content.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/utils/get_wishlist_theme.dart';
import 'package:wishlist/shared/theme/widgets/app_refresh_indicator.dart';
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
  WishlistStatsCardType statCardSelected = WishlistStatsCardType.pending;

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

  @override
  Widget build(BuildContext context) {
    final wishlistScreenData =
        ref.watch(wishlistScreenDataProvider(widget.wishlistId));

    return Scaffold(
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
                // Needed to have the context with wishlist theme
                return Scaffold(
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(70),
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
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(32)),
                      ),
                    ),
                  ),
                  body: _buildWishlistDetail(
                    wishlistScreenData,
                    context,
                    ref,
                    isMyWishlist: isMyWishlist,
                  ),
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
    final l10n = context.l10n;
    final wishlist = wishlistScreenData.wishlist;
    final wishs = wishlistScreenData.wishs;

    final nbWishsPending =
        wishs.where((wish) => wish.takenByUser.isEmpty).length;
    final nbWishsBooked =
        wishs.where((wish) => wish.takenByUser.isNotEmpty).length;

    final hasWishsNotTaken = wishs.any((wish) => wish.takenByUser.isEmpty);
    final hasWishsTaken = wishs.any((wish) => wish.takenByUser.isNotEmpty);

    final shouldDisplayWishs =
        hasWishsNotTaken && statCardSelected == WishlistStatsCardType.pending ||
            hasWishsTaken && statCardSelected == WishlistStatsCardType.booked;

    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: WishlistStatsCard(
                      type: WishlistStatsCardType.pending,
                      isSelected:
                          statCardSelected == WishlistStatsCardType.pending,
                      count: nbWishsPending,
                      onTap: () => onTapStatCard(WishlistStatsCardType.pending),
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: WishlistStatsCard(
                      type: WishlistStatsCardType.booked,
                      isSelected:
                          statCardSelected == WishlistStatsCardType.booked,
                      count: nbWishsBooked,
                      onTap: () => onTapStatCard(WishlistStatsCardType.booked),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.gainsboro,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return shouldDisplayWishs
                        ? AppRefreshIndicator(
                            onRefresh: () => ref
                                .read(
                                  wishsFromWishlistProvider(
                                    wishlist.id,
                                  ).notifier,
                                )
                                .loadWishs(),
                            child: ListView.separated(
                              itemCount: wishs.length,
                              separatorBuilder: (context, index) =>
                                  const Gap(8),
                              itemBuilder: (context, index) {
                                final wish = wishs[index];
                                if (statCardSelected ==
                                    WishlistStatsCardType.booked) {
                                  return WishCard(
                                    key: ValueKey(wish.id),
                                    wish: wish,
                                    onTap: () => onTapWish(
                                      context,
                                      wish,
                                      isMyWishlist: isMyWishlist,
                                    ),
                                  );
                                } else if (statCardSelected ==
                                    WishlistStatsCardType.pending) {
                                  return WishCard(
                                    key: ValueKey(wish.id),
                                    wish: wish,
                                    onTap: () => onTapWish(
                                      context,
                                      wish,
                                      isMyWishlist: isMyWishlist,
                                    ),
                                  );
                                }
                                return null;
                              },
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: PageLayoutEmptyContent(
                              illustrationUrl: Assets.svg.noWishlist,
                              illustrationHeight: constraints.maxHeight / 2,
                              title: l10n.wishlistNoWish,
                              callToAction:
                                  isMyWishlist ? l10n.wishlistAddWish : null,
                              onCallToAction: isMyWishlist
                                  ? () => onAddWish(context, wishlist)
                                  : null,
                            ),
                          );
                  },
                ),
              ),
            ),
          ],
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
  }
}
