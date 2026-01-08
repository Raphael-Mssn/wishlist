import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/gen/assets.gen.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/infra/wishlists_realtime_provider.dart';
import 'package:wishlist/shared/page_layout_empty/page_layout_empty.dart';
import 'package:wishlist/shared/theme/widgets/app_scaffold.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/widgets/dialogs/create_dialog.dart';
import 'package:wishlist/shared/widgets/page_layout.dart';
import 'package:wishlist/shared/widgets/wishlists_grid.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final wishlists = ref.watch(wishlistsRealtimeProvider);

    Future<void> refreshWishlists() async {
      ref.invalidate(wishlistsRealtimeProvider);

      // Attendre que le nouveau stream soit initialisé
      await ref.read(wishlistsRealtimeProvider.future);
    }

    return wishlists.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) {
        showGenericError(context, isTopSnackBar: true);
        return const SizedBox.shrink();
      },
      data: (data) => data.isEmpty
          ? PageLayoutEmpty(
              illustrationUrl: Assets.svg.noWishlist,
              title: l10n.noWishlist,
              callToAction: l10n.createButton,
              onCallToAction: () {
                showCreateDialog(context, ref);
              },
              onRefresh: refreshWishlists,
              appBarTitle: l10n.wishlistsScreenTitle,
            )
          : PageLayout(
              padding: EdgeInsets.zero,
              title: l10n.wishlistsScreenTitle,
              onRefresh: refreshWishlists,
              child: WishlistsGrid(
                wishlists: data,
                isReorderable: true,
                padding: const EdgeInsets.all(20).copyWith(
                  bottom: NavBarPadding.of(context),
                ),
              ),
            ),
    );
  }
}
