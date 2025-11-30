import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wishlist/shared/infra/wishlist_service.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/widgets/wishlist_card.dart';

class WishlistsGrid extends ConsumerStatefulWidget {
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
  ConsumerState<WishlistsGrid> createState() => _WishlistsGridState();
}

class _WishlistsGridState extends ConsumerState<WishlistsGrid> {
  static const _animationDuration = Duration(milliseconds: 500);
  static const _crossAxisCount = 2;
  static const _optimisticResetDelay = Duration(milliseconds: 500);

  List<Wishlist>? _optimisticWishlists;
  bool _isReordering = false;

  List<Wishlist> get _displayedWishlists =>
      _optimisticWishlists ?? widget.wishlists;

  @override
  void didUpdateWidget(WishlistsGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isReordering) {
      _optimisticWishlists = null;
    }
  }

  Future<void> _handleReorder(int oldIndex, int newIndex) async {
    setState(() => _isReordering = true);

    final reorderedWishlists = List<Wishlist>.from(_displayedWishlists);
    final wishlist = reorderedWishlists.removeAt(oldIndex);
    reorderedWishlists.insert(newIndex, wishlist);

    setState(() => _optimisticWishlists = reorderedWishlists);

    try {
      await ref
          .read(wishlistServiceProvider)
          .updateWishlistsOrder(reorderedWishlists.toIList());
    } finally {
      _resetOptimisticState();
    }
  }

  void _resetOptimisticState() {
    Future.delayed(_optimisticResetDelay, () {
      if (mounted) {
        setState(() {
          _isReordering = false;
          _optimisticWishlists = null;
        });
      }
    });
  }

  Widget _buildWishlistCard(Wishlist wishlist, int index) {
    return AnimationConfiguration.staggeredList(
      key: Key(wishlist.id.toString()),
      duration: _animationDuration,
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

  Widget _buildProxyDecorator(
    Widget child,
    int index,
    Animation<double> animation,
  ) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ).drive(Tween(begin: 1, end: 1.2)),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    const sliverGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: _crossAxisCount,
    );

    if (!widget.isReorderable) {
      return AnimationLimiter(
        child: SliverGrid(
          gridDelegate: sliverGridDelegate,
          delegate: SliverChildBuilderDelegate(
            (context, index) =>
                _buildWishlistCard(widget.wishlists[index], index),
            childCount: widget.wishlists.length,
          ),
        ),
      );
    }

    return AnimationLimiter(
      child: AnimatedReorderableGridView(
        padding: widget.padding,
        items: _displayedWishlists,
        onReorder: _handleReorder,
        proxyDecorator: _buildProxyDecorator,
        sliverGridDelegate: sliverGridDelegate,
        isSameItem: (a, b) => a.id == b.id,
        enterTransition: [
          FadeIn(
            curve: Curves.easeInOut,
            duration: _animationDuration,
          ),
          ScaleIn(
            curve: Curves.easeInOut,
            duration: _animationDuration,
          ),
        ],
        itemBuilder: (context, index) =>
            _buildWishlistCard(_displayedWishlists[index], index),
      ),
    );
  }
}
