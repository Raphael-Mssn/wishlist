import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/friends/view/widgets/friend_details_app_bar.dart';
import 'package:wishlist/modules/friends/view/widgets/friend_pill.dart';
import 'package:wishlist/shared/infra/friend_details_realtime_provider.dart';
import 'package:wishlist/shared/models/friend_details/friend_details.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/app_refresh_indicator.dart';
import 'package:wishlist/shared/widgets/avatar/app_avatar.dart';
import 'package:wishlist/shared/widgets/wishlists_grid.dart';

class FriendDetailsScreen extends ConsumerWidget {
  const FriendDetailsScreen({super.key, required this.friendId});
  final String friendId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendDetails = ref.watch(friendDetailsRealtimeProvider(friendId));

    Future<void> refreshFriendDetails() async {
      ref.invalidate(friendDetailsRealtimeProvider(friendId));

      // Attendre que le nouveau stream soit initialisé
      await ref.read(friendDetailsRealtimeProvider(friendId).future);
    }

    return Scaffold(
      body: friendDetails.when(
        data: (friendDetails) => _FriendDetailsScreen(
          friendDetails: friendDetails,
          onRefresh: refreshFriendDetails,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const SizedBox.shrink(),
      ),
    );
  }
}

class _FriendDetailsScreen extends StatelessWidget {
  const _FriendDetailsScreen({
    required this.friendDetails,
    required this.onRefresh,
  });
  final FriendDetails friendDetails;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FriendDetailsAppBar(
        friend: friendDetails.appUser,
      ),
      body: AppRefreshIndicator(
        onRefresh: onRefresh,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(30, 16, 30, 30),
              sliver: SliverMainAxisGroup(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      // Stats
                      _FriendStatsSection(friendDetails: friendDetails),
                      const Gap(24),

                      // Mutual friends
                      _MutualFriendsTitleAndSection(
                        friendDetails: friendDetails,
                      ),
                      const Gap(24),

                      // Wishlists
                      const _WishlistsTitle(),
                      const Gap(12),
                    ]),
                  ),
                  _WishlistsSection(friendDetails: friendDetails),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FriendStatsSection extends ConsumerWidget {
  const _FriendStatsSection({required this.friendDetails});
  final FriendDetails friendDetails;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final nbWishlists = l10n.numberOfWishlists(friendDetails.nbWishlists);
    final nbWishs = l10n.numberOfWishs(friendDetails.nbWishs);
    final personalStats = '$nbWishlists | $nbWishs';
    const avatarSize = 80.0;

    return Row(
      children: [
        AppAvatar(
          avatarUrl: friendDetails.appUser.profile.avatarUrl,
          size: avatarSize,
        ),
        const Gap(16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              friendDetails.appUser.profile.pseudo,
              style: AppTextStyles.titleSmall,
            ),
            Text(
              personalStats,
              style: AppTextStyles.smaller.copyWith(
                color: AppColors.makara,
                height: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MutualFriendsTitleAndSection extends StatefulWidget {
  const _MutualFriendsTitleAndSection({required this.friendDetails});
  final FriendDetails friendDetails;

  @override
  State<_MutualFriendsTitleAndSection> createState() =>
      _MutualFriendsTitleAndSectionState();
}

class _MutualFriendsTitleAndSectionState
    extends State<_MutualFriendsTitleAndSection> {
  static const int _maxVisibleFriends = 3;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final mutualFriends = widget.friendDetails.mutualFriends.toList();
    final hasMoreFriends = mutualFriends.length > _maxVisibleFriends;
    final nbFriendsNotVisible = mutualFriends.length - _maxVisibleFriends;

    final seeAllAnimationDurationMs = nbFriendsNotVisible * 100;

    const hideAllAnimationDurationMs = 300;

    final animationDurationMs =
        _isExpanded ? seeAllAnimationDurationMs : hideAllAnimationDurationMs;

    final heightFactor = _isExpanded
        ? 1.0
        : min(_maxVisibleFriends, mutualFriends.length) / mutualFriends.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title row with "See all" / "Hide" button
        Row(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: ' ${l10n.friendDetailsMutualFriendsTitle}',
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.makara,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (nbFriendsNotVisible > 0) ...[
                    const WidgetSpan(child: SizedBox(width: 2)),
                    TextSpan(
                      text: '(${mutualFriends.length})',
                      style: AppTextStyles.smaller.copyWith(
                        color: AppColors.makara,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (hasMoreFriends) ...[
              const Spacer(),
              TextButton(
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
                child: Text(
                  _isExpanded ? l10n.hide : l10n.seeAll,
                  style: AppTextStyles.smaller.copyWith(
                    color: AppColors.makara,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        const Gap(12),
        // Mutual friends list
        if (mutualFriends.isEmpty)
          Center(
            child: Text(
              l10n.friendDetailsNoMutualFriends,
              style: AppTextStyles.smaller.copyWith(
                color: AppColors.makara,
              ),
            ),
          )
        else
          ClipRect(
            child: AnimatedAlign(
              duration: Duration(milliseconds: animationDurationMs),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topCenter,
              heightFactor: heightFactor,
              child: Column(
                children: [
                  for (final friend in mutualFriends)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: FriendPill(appUser: friend),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _WishlistsTitle extends StatelessWidget {
  const _WishlistsTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.friendDetailsWishlistsTitle,
      style: AppTextStyles.small.copyWith(
        color: AppColors.makara,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _WishlistsSection extends StatelessWidget {
  const _WishlistsSection({required this.friendDetails});
  final FriendDetails friendDetails;

  @override
  Widget build(BuildContext context) {
    if (friendDetails.publicWishlists.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Text(
            context.l10n.noWishlist,
            style: AppTextStyles.smaller.copyWith(
              color: AppColors.makara,
            ),
          ),
        ),
      );
    }

    return WishlistsGrid(
      wishlists: friendDetails.publicWishlists.toList(),
      isReorderable: false,
    );
  }
}
