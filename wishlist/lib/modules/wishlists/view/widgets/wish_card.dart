import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_stats_card.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/providers/wishlist_theme_provider.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/pill.dart';
import 'package:wishlist/shared/utils/formatters.dart';
import 'package:wishlist/shared/widgets/avatar/stacked_avatars.dart';
import 'package:wishlist/shared/widgets/wish_image.dart';

class WishCard extends ConsumerWidget {
  const WishCard({
    super.key,
    required this.wish,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.isMyWishlist,
    required this.cardType,
    this.subtitle,
    this.quantityOverride,
    this.onLongPress,
    this.isSelected = false,
    this.showAvatars = true,
  });

  static const double _cardPadding = 12;
  static const double _selectionBorderWidth = 3;

  final Wish wish;
  final void Function() onTap;
  final void Function() onFavoriteToggle;
  final bool isMyWishlist;
  final WishlistStatsCardType cardType;
  final String? subtitle;
  final int? quantityOverride;
  final VoidCallback? onLongPress;
  final bool isSelected;
  final bool showAvatars;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistThemeAsync =
        ref.watch(wishlistThemeProvider(wish.wishlistId));

    return wishlistThemeAsync.when(
      data: (wishlistTheme) => _buildCard(context, wishlistTheme.primaryColor),
      loading: () => _buildCard(context, AppColors.primary),
      error: (_, __) => _buildCard(context, AppColors.primary),
    );
  }

  Widget _buildCard(BuildContext context, Color primaryColor) {
    final price = wish.price;
    final subtitle = this.subtitle;
    final hasSubtitle = subtitle != null && subtitle.isNotEmpty;
    final hasPrice = price != null;
    final shouldDisplayFavouriteIcon =
        isMyWishlist || (!isMyWishlist && wish.isFavourite);
    final shouldDisplayAvatars = showAvatars &&
        cardType == WishlistStatsCardType.booked &&
        wish.takenByUser.isNotEmpty;

    final borderRadius = BorderRadius.circular(24);

    // Calculer la quantité à afficher selon le contexte
    final quantityToDisplay = quantityOverride ?? _getQuantityToDisplay();

    final cardPadding =
        isSelected ? _cardPadding - _selectionBorderWidth : _cardPadding;

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        onLongPress: onLongPress,
        child: Stack(
          children: [
            Ink(
              padding: EdgeInsets.all(cardPadding),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
                border: isSelected
                    ? Border.all(
                        color: primaryColor,
                        width: _selectionBorderWidth,
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      WishImage(
                        iconUrl: wish.iconUrl,
                      ),
                      if (quantityToDisplay > 1)
                        Positioned(
                          bottom: -4,
                          right: -4,
                          child: Pill(
                            text: 'x$quantityToDisplay',
                            backgroundColor: primaryColor,
                            textStyle: AppTextStyles.smaller,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            right: shouldDisplayFavouriteIcon ? 12 : 0,
                          ),
                          child: Transform.translate(
                            offset: shouldDisplayAvatars
                                ? const Offset(0, -6)
                                : Offset.zero,
                            child: Text(
                              wish.name,
                              maxLines: 2,
                              textHeightBehavior: const TextHeightBehavior(
                                applyHeightToFirstAscent: false,
                                applyHeightToLastDescent: false,
                              ),
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.small.copyWith(
                                color: AppColors.darkGrey,
                                fontWeight: FontWeight.w600,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),
                        if (hasSubtitle ||
                            hasPrice ||
                            shouldDisplayAvatars) ...[
                          const Gap(2),
                          if (hasSubtitle)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    subtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.smaller.copyWith(
                                      color: AppColors.makara,
                                      fontWeight: FontWeight.normal,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                                if (hasPrice) ...[
                                  const Gap(8),
                                  Text(
                                    Formatters.currency(price),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.small.copyWith(
                                      color: AppColors.darkGrey,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ],
                            )
                          else if (hasPrice)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  Formatters.currency(price),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.small.copyWith(
                                    color: AppColors.darkGrey,
                                    height: 1,
                                  ),
                                ),
                              ),
                            )
                          else if (shouldDisplayAvatars)
                            const SizedBox(height: 14),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (shouldDisplayAvatars)
              Positioned(
                left: cardPadding + 80,
                top: cardPadding + 36,
                child: _WishReserversAvatars(
                  wish: wish,
                ),
              ),
            if (isSelected)
              Positioned(
                top: 8,
                left: 8,
                child: _SelectionCheckIcon(color: primaryColor),
              ),
            if (shouldDisplayFavouriteIcon)
              Positioned(
                top: 4,
                right: 4,
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: isMyWishlist ? onFavoriteToggle : null,
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      child: Icon(
                        wish.isFavourite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: wish.isFavourite
                            ? AppColors.favorite
                            : AppColors.makara,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  int _getQuantityToDisplay() {
    switch (cardType) {
      case WishlistStatsCardType.pending:
        return wish.availableQuantity;
      case WishlistStatsCardType.booked:
        return wish.totalBookedQuantity;
    }
  }
}

class _SelectionCheckIcon extends StatelessWidget {
  const _SelectionCheckIcon({
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.background,
          width: 2,
        ),
      ),
      child: const Icon(
        Icons.check,
        color: AppColors.background,
        size: 16,
      ),
    );
  }
}

/// Widget qui affiche les avatars des utilisateurs qui ont réservé ce wish
class _WishReserversAvatars extends StatelessWidget {
  const _WishReserversAvatars({
    required this.wish,
  });

  final Wish wish;

  @override
  Widget build(BuildContext context) {
    final userNames = wish.takenByUser
        .map((t) => t.userPseudo ?? 'Utilisateur inconnu')
        .toList();
    final avatarUrls = wish.takenByUser.map((t) => t.userAvatarUrl).toList();

    if (avatarUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    final tooltipMessage = userNames.length == 1
        ? userNames.first
        : userNames.map((name) => '• $name').join('\n');

    return Tooltip(
      message: tooltipMessage,
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(seconds: 2),
      waitDuration: Duration.zero,
      child: StackedAvatars(
        avatarUrls: avatarUrls,
      ),
    );
  }
}
