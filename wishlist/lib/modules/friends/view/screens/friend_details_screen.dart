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
      body: Padding(
        padding: const EdgeInsets.all(30).copyWith(top: 16),
        child: AppRefreshIndicator(
          onRefresh: onRefresh,
          child: CustomScrollView(
            slivers: [
              // Stats
              SliverToBoxAdapter(
                child: _FriendStatsSection(friendDetails: friendDetails),
              ),
              const _SliverGap(48),

              // Mutual friends
              const SliverToBoxAdapter(
                child: _MutualFriendsTitle(),
              ),
              const _SliverGap(16),
              SliverToBoxAdapter(
                child: _MutualFriendsSection(friendDetails: friendDetails),
              ),
              const _SliverGap(32),

              // Wishlists
              const SliverToBoxAdapter(
                child: _WishlistsTitle(),
              ),
              const _SliverGap(16),
              _WishlistsSection(friendDetails: friendDetails),
            ],
          ),
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
              style: AppTextStyles.medium.copyWith(height: 0),
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

class _MutualFriendsTitle extends StatelessWidget {
  const _MutualFriendsTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.friendDetailsMutualFriendsTitle,
      style: AppTextStyles.small.copyWith(
        color: AppColors.makara,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _MutualFriendsSection extends StatelessWidget {
  const _MutualFriendsSection({required this.friendDetails});
  final FriendDetails friendDetails;

  @override
  Widget build(BuildContext context) {
    if (friendDetails.mutualFriends.isEmpty) {
      return Center(
        child: Text(
          context.l10n.friendDetailsNoMutualFriends,
          style: AppTextStyles.smaller.copyWith(
            color: AppColors.makara,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final friend in friendDetails.mutualFriends)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: FriendPill(appUser: friend),
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

class _SliverGap extends StatelessWidget {
  const _SliverGap(this.size);
  final double size;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Gap(size),
    );
  }
}
