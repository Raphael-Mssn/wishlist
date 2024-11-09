import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/gen/assets.gen.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishlists/infra/wishlist_screen_data_provider.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wish_card.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_params_bottom_sheet.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_card.dart';
import 'package:wishlist/modules/wishs/create_wish_bottom_sheet.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/page_layout_empty/page_layout_empty_content.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/utils/get_wishlist_theme.dart';
import 'package:wishlist/shared/widgets/nav_bar_add_button.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({
    super.key,
    required this.wishlistId,
  });

  final int wishlistId;

  void onAddWish(BuildContext context, Wishlist wishlist) {
    showCreateWishBottomSheet(context, wishlist);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistScreenData =
        ref.watch(wishlistScreenDataProvider(wishlistId));

    return Scaffold(
      body: wishlistScreenData.when(
        data: (wishlistScreenData) {
          final wishlist = wishlistScreenData.wishlist;
          final wishlistTheme = getWishlistTheme(context, wishlist);
          final isMyWishlist = wishlist.idOwner ==
              ref.read(userServiceProvider).getCurrentUserId();

          return AnimatedTheme(
            data: wishlistTheme,
            child: Scaffold(
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
                          onPressed: () =>
                              showWishlistParamsBottomSheet(context, wishlist),
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
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(32)),
                  ),
                ),
              ),
              body: _buildWishlistDetail(
                wishlistScreenData,
                context,
                isMyWishlist: isMyWishlist,
              ),
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
    BuildContext context, {
    required bool isMyWishlist,
  }) {
    final l10n = context.l10n;
    final wishlist = wishlistScreenData.wishlist;
    final wishs = wishlistScreenData.wishs;
    final hasWishs = wishs.isNotEmpty;

    return Stack(
      children: [
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: WishlistStatsCard(
                      type: WishlistStatsCardType.pending,
                      // TODO: Get the count of pending wishes
                      count: 0,
                    ),
                  ),
                  Gap(16),
                  Expanded(
                    child: WishlistStatsCard(
                      type: WishlistStatsCardType.booked,
                      // TODO: Get the count of booked wishes
                      count: 2,
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
                    return hasWishs
                        ? ListView.separated(
                            itemCount: wishs.length,
                            separatorBuilder: (context, index) => const Gap(8),
                            itemBuilder: (context, index) {
                              final wish = wishs[index];
                              return WishCard(
                                key: ValueKey(wish.id),
                                wish: wish,
                              );
                            },
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
