import 'package:animated_reorderable/animated_reorderable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wishlist/gen/assets.gen.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/infra/non_null_extensions/go_true_client_non_null_getter_user_extension.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';
import 'package:wishlist/shared/infra/wishlist_service.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/widgets/app_card.dart';
import 'package:wishlist/shared/widgets/dialogs/create_dialog.dart';
import 'package:wishlist/shared/widgets/page_layout.dart';
import 'package:wishlist/shared/widgets/page_layout_empty.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<List<Wishlist>> _wishlistsFuture;

  @override
  void initState() {
    super.initState();
    _wishlistsFuture = ref.read(wishlistServiceProvider).getWishlistsByUser(
          ref.read(supabaseClientProvider).auth.currentUserNonNull.id,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FutureBuilder<List<Wishlist>>(
      future: _wishlistsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final wishlists = snapshot.data!;
          if (wishlists.isEmpty) {
            return PageLayoutEmpty(
              illustrationUrl: Assets.svg.noWishlist,
              title: l10n.noWishlist,
              callToAction: l10n.createButton,
              onCallToAction: () {
                showCreateDialog(context, ref);
              },
            );
          } else {
            return PageLayout(
              padding: EdgeInsets.zero,
              title: l10n.myWishlists,
              child: AnimationLimiter(
                child: AnimatedReorderable.grid(
                  keyGetter: (index) => Key(wishlists[index].id.toString()),
                  motionAnimationDuration: const Duration(milliseconds: 200),
                  draggedItemDecorationAnimationDuration: const Duration(
                    milliseconds: 200,
                  ),
                  onReorder: (permutations) {
                    setState(() {
                      permutations.apply(wishlists);
                      ref
                          .read(wishlistServiceProvider)
                          .updateWishlistsOrder(wishlists);
                    });
                  },
                  draggedItemDecorator: (
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
                  gridView: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ).copyWith(
                      top: 16,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: wishlists.length,
                    itemBuilder: (context, index) {
                      final wishlist = wishlists[index];
                      return AnimationConfiguration.staggeredList(
                        duration: const Duration(milliseconds: 500),
                        position: index,
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: AppCard(
                              text: wishlist.name,
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
        } else {
          return Text(l10n.genericError);
        }
      },
    );
  }
}
