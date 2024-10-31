import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/gen/assets.gen.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/infra/non_null_extensions/go_true_client_non_null_getter_user_extension.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';
import 'package:wishlist/shared/infra/utils/scaffold_messenger_extension.dart';
import 'package:wishlist/shared/infra/wishlists_provider.dart';
import 'package:wishlist/shared/page_layout_empty/page_layout_empty.dart';
import 'package:wishlist/shared/widgets/dialogs/create_dialog.dart';
import 'package:wishlist/shared/widgets/page_layout.dart';
import 'package:wishlist/shared/widgets/wishlists_grid.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final wishlists = ref.watch(wishlistsProvider);

    Future<void> refreshWishlists() async {
      await ref.read(wishlistsProvider.notifier).loadWishlists(
            ref.read(supabaseClientProvider).auth.currentUserNonNull.id,
          );
    }

    return wishlists.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) {
        ScaffoldMessenger.of(context)
            .showGenericError(context, isTopSnackBar: true);
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
            )
          : PageLayout(
              padding: EdgeInsets.zero,
              title: l10n.myWishlists,
              onRefresh: refreshWishlists,
              child: Padding(
                padding: const EdgeInsets.all(16).copyWith(bottom: 96),
                child: WishlistsGrid(
                  wishlists: data,
                  isReorderable: true,
                ),
              ),
            ),
    );
  }
}
