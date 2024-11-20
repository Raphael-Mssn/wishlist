import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wishlist/shared/infra/wishlist_service.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/widgets/wishlist_card.dart';

class WishlistsGrid extends ConsumerWidget {
  const WishlistsGrid({
    super.key,
    required this.wishlists,
    required this.isReorderable,
    this.padding,
  });

  final List<Wishlist> wishlists;
  final bool isReorderable;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const sliverGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
    );
    const animationDuration = Duration(milliseconds: 500);

    Widget buildWishlistCard(Wishlist wishlist, int index) {
      return AnimationConfiguration.staggeredList(
        key: Key(wishlist.id.toString()),
        duration: animationDuration,
        position: index,
        child: ScaleAnimation(
          child: FadeInAnimation(
            child: WishlistCard(
              wishlist: wishlist,
              color: AppColors.getColorFromHexValue(wishlist.color),
            ),
          ),
        ),
      );
    }

    Widget buildReorderable() {
      return AnimatedReorderableGridView(
        padding: padding,
        items: wishlists,
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
          final wishlist = wishlists.removeAt(oldIndex);
          wishlists.insert(newIndex, wishlist);
          ref
              .read(wishlistServiceProvider)
              .updateWishlistsOrder(wishlists.toIList());
        },
        sliverGridDelegate: sliverGridDelegate,
        isSameItem: (a, b) => a.id == b.id,
        enterTransition: [
          FadeIn(
            curve: Curves.easeInOut,
            duration: animationDuration,
          ),
          ScaleIn(
            curve: Curves.easeInOut,
            duration: animationDuration,
          ),
        ],
        itemBuilder: (context, index) {
          return buildWishlistCard(wishlists[index], index);
        },
      );
    }

    Widget buildNonReorderable() {
      return SliverGrid(
        gridDelegate: sliverGridDelegate,
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return buildWishlistCard(wishlists[index], index);
          },
          childCount: wishlists.length,
        ),
      );
    }

    return AnimationLimiter(
      child: isReorderable ? buildReorderable() : buildNonReorderable(),
    );
  }
}
