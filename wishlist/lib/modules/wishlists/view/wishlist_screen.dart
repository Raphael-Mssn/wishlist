import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/gen/assets.gen.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishlists/infra/wishlist_by_id_provider.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_params_bottom_sheet.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_card.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/page_layout_empty/page_layout_empty_content.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/widgets/nav_bar_add_button.dart';

const _argumentError = 'Provide either wishlistId or wishlist';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({
    super.key,
    this.wishlistId,
    this.wishlist,
  }) : assert(
          wishlistId != null || wishlist != null,
          _argumentError,
        );

  final int? wishlistId;
  final Wishlist? wishlist;

  void onAddWish() {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = this.wishlist;
    final wishlistId = this.wishlistId;

    // Si wishlist est déjà fourni, pas besoin de faire l'appel API
    final wishlistAsyncValue = wishlist != null
        ? AsyncValue.data(wishlist)
        : (wishlistId != null
            ? ref.watch(wishlistByIdProvider(wishlistId))
            : throw ArgumentError(_argumentError));

    return Scaffold(
      body: wishlistAsyncValue.when(
        data: (wishlist) {
          final wishlistColor = AppColors.getColorFromHexValue(wishlist.color);
          final wishlistDarkColor = AppColors.darken(wishlistColor);
          final currentTheme = Theme.of(context);

          return AnimatedTheme(
            data: currentTheme.copyWith(
              primaryColor: wishlistColor,
              primaryColorDark: wishlistDarkColor,
              appBarTheme: currentTheme.appBarTheme.copyWith(
                backgroundColor: wishlistColor,
              ),
            ),
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(70),
                child: AppBar(
                  actions: [
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
              body: _buildWishlistDetail(wishlist, context),
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

  Widget _buildWishlistDetail(Wishlist wishlist, BuildContext context) {
    final l10n = context.l10n;

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
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: PageLayoutEmptyContent(
                        illustrationUrl: Assets.svg.noWishlist,
                        illustrationHeight: constraints.maxHeight / 2,
                        title: l10n.wishlistNoWish,
                        callToAction: l10n.wishlistAddWish,
                        onCallToAction: onAddWish,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Align(
              alignment: Alignment.centerRight,
              child: NavBarAddButton(
                icon: Icons.add,
                onPressed: onAddWish,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
