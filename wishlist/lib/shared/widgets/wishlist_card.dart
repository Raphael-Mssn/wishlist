import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/app_wave_pattern.dart';

class WishlistCard extends ConsumerWidget {
  const WishlistCard({
    super.key,
    required this.wishlist,
    required this.color,
  });

  final Wishlist wishlist;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final borderRadius = BorderRadius.circular(36);
    final currentUserId =
        ref.watch(supabaseClientProvider).auth.currentUser?.id;
    final isOwner = currentUserId == wishlist.idOwner;

    void onTap() {
      WishlistRoute(wishlistId: wishlist.id).push(context);
    }

    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: AppWavePattern(
        backgroundColor: color,
        preset: WavePreset.card,
        rotationType: WaveRotationType.deterministic,
        deterministicId: wishlist.id,
        borderRadius: borderRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (wishlist.visibility == WishlistVisibility.private)
                    _WishlistBadge(
                      icon: Icons.lock,
                      color: color,
                    ),
                  if (!isOwner && !wishlist.canOwnerSeeTakenWish) ...[
                    if (wishlist.visibility == WishlistVisibility.private)
                      const SizedBox(width: 8),
                    _WishlistBadge(
                      icon: Icons.visibility_off,
                      color: color,
                    ),
                  ],
                ],
              ),
              const Gap(4),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    wishlist.name,
                    style: AppTextStyles.medium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WishlistBadge extends StatelessWidget {
  const _WishlistBadge({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.gainsboro,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 16,
        color: AppColors.makara,
      ),
    );
  }
}
