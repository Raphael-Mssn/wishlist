import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishs/view/widgets/consult_wish_back_button.dart';
import 'package:wishlist/modules/wishs/view/widgets/consult_wish_image.dart';
import 'package:wishlist/modules/wishs/view/widgets/consult_wish_info_container.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_streams_providers.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/providers/wishlist_theme_provider.dart';

class ConsultWishScreen extends ConsumerStatefulWidget {
  const ConsultWishScreen({
    super.key,
    required this.wishId,
    this.isMyWishlist = false,
    this.wishIds,
    this.initialIndex,
  });

  final int wishId;
  final bool isMyWishlist;
  final List<int>? wishIds;
  final int? initialIndex;

  @override
  ConsumerState<ConsultWishScreen> createState() => _ConsultWishScreenState();
}

class _ConsultWishScreenState extends ConsumerState<ConsultWishScreen> {
  late PageController _pageController;
  late int _currentWishId;

  @override
  void initState() {
    super.initState();
    _currentWishId = widget.wishId;
    _pageController = PageController(
      initialPage: widget.initialIndex ?? 0,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    final wishIds = widget.wishIds;
    if (wishIds != null && index < wishIds.length) {
      setState(() {
        _currentWishId = wishIds[index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final wish = ref.watch(watchWishByIdProvider(_currentWishId));
    final wishIds = widget.wishIds;

    // Si on a une liste de wishIds, on utilise un PageView
    if (wishIds != null && wishIds.isNotEmpty) {
      return _buildPageView(l10n);
    }

    // Sinon, affichage simple (comportement actuel)
    return _buildSingleWish(wish, l10n);
  }

  Widget _buildPageView(AppLocalizations l10n) {
    final wishIds = widget.wishIds;
    if (wishIds == null) {
      return const SizedBox.shrink();
    }

    return PageView.builder(
      controller: _pageController,
      onPageChanged: _onPageChanged,
      itemCount: wishIds.length,
      itemBuilder: (context, index) {
        final wishId = wishIds[index];
        final wish = ref.watch(watchWishByIdProvider(wishId));
        return _buildSingleWish(wish, l10n);
      },
    );
  }

  Widget _buildSingleWish(
    AsyncValue wish,
    AppLocalizations l10n,
  ) {
    return wish.when(
      data: (wishData) {
        final wishlistThemeAsync =
            ref.watch(wishlistThemeProvider(wishData.wishlistId));

        return wishlistThemeAsync.when(
          data: (wishlistTheme) {
            final descriptionText = wishData.description.isNotEmpty
                ? wishData.description
                : l10n.noDescription;

            return AnimatedTheme(
              data: wishlistTheme,
              child: Scaffold(
                backgroundColor: AppColors.gainsboro,
                body: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          const Gap(64),
                          const ConsultWishBackButton(),
                          const Gap(16),
                          ConsultWishImage(wish: wishData),
                          const Gap(32),
                          ConsultWishInfoContainer(
                            wish: wishData,
                            descriptionText: descriptionText,
                            isMyWishlist: widget.isMyWishlist,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const Scaffold(
            backgroundColor: AppColors.gainsboro,
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const Scaffold(
            backgroundColor: AppColors.gainsboro,
            body: SizedBox.shrink(),
          ),
        );
      },
      error: (error, stackTrace) => const Scaffold(
        backgroundColor: AppColors.gainsboro,
        body: SizedBox.shrink(),
      ),
      loading: () => const Scaffold(
        backgroundColor: AppColors.gainsboro,
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
