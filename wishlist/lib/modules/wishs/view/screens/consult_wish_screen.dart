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

class ConsultWishScreen extends ConsumerWidget {
  const ConsultWishScreen({
    super.key,
    required this.wishId,
    this.isMyWishlist = false,
  });

  final int wishId;
  final bool isMyWishlist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final wish = ref.watch(watchWishByIdProvider(wishId));

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
                            isMyWishlist: isMyWishlist,
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
