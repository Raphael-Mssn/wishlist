import 'package:flutter/material.dart';

import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

/// Tuile d'affichage d'une wishlist (pastille couleur + nom).
/// Réutilisée pour la sélection de wishlist (add-wish, déplacer des wishes).
class WishlistListTile extends StatelessWidget {
  const WishlistListTile({
    super.key,
    required this.wishlist,
    required this.onTap,
    this.isSelected = false,
    this.trailing,
  });

  final Wishlist wishlist;
  final VoidCallback onTap;

  /// Si true, le titre est en gras et coloré, et [trailing] est ignoré
  /// au profit d'une icône check.
  final bool isSelected;

  /// Icône de fin (ex. flèche pour navigation).
  /// Ignoré si [isSelected] est true.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final wishlistColor = AppColors.getColorFromHexValue(wishlist.color);

    return ListTile(
      leading: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: wishlistColor,
          shape: BoxShape.circle,
        ),
      ),
      title: Text(
        wishlist.name,
        style: AppTextStyles.medium.copyWith(
          color: isSelected ? wishlistColor : AppColors.darkGrey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected ? Icon(Icons.check, color: wishlistColor) : trailing,
      onTap: onTap,
    );
  }
}
