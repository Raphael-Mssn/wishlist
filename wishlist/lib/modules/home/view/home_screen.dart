import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wishlist/gen/assets.gen.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/infra/non_null_extensions/go_true_client_non_null_getter_user_extension.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';
import 'package:wishlist/shared/infra/utils/scaffold_messenger_extension.dart';
import 'package:wishlist/shared/infra/wishlist_service.dart';
import 'package:wishlist/shared/infra/wishlists_provider.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/widgets/dialogs/create_dialog.dart';
import 'package:wishlist/shared/widgets/page_layout.dart';
import 'package:wishlist/shared/widgets/page_layout_empty.dart';
import 'package:wishlist/shared/widgets/wishlist_card.dart';

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
              child: AnimationLimiter(
                child: AnimatedReorderableGridView(
                  padding: const EdgeInsets.all(16),
                  items: data,
                  proxyDecorator: (
                    child,
                    index,
                    animation,
                  ) =>
                      ScaleTransition(
                    scale: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    ).drive(Tween(begin: 1, end: 1.2)),
                    child: child,
                  ),
                  onReorder: (oldIndex, newIndex) {
                    final wishlist = data.removeAt(oldIndex);
                    data.insert(newIndex, wishlist);

                    ref
                        .read(wishlistServiceProvider)
                        .updateWishlistsOrder(data.toIList());
                  },
                  sliverGridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  isSameItem: (a, b) => a.id == b.id,
                  enterTransition: [
                    FadeIn(
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 500),
                    ),
                    ScaleIn(
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 500),
                    ),
                  ],
                  itemBuilder: (context, index) {
                    final wishlist = data[index];
                    return AnimationConfiguration.staggeredList(
                      key: Key(wishlist.id.toString()),
                      duration: const Duration(milliseconds: 500),
                      position: index,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: WishlistCard(
                            wishlist: wishlist,
                            color: AppColors.getColorFromHexValue(
                              wishlist.color,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
