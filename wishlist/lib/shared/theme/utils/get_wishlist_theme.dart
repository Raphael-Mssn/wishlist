import 'package:flutter/material.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/theme/colors.dart';

ThemeData getWishlistTheme(BuildContext context, Wishlist wishlist) {
  final wishlistColor = AppColors.getColorFromHexValue(wishlist.color);
  final wishlistDarkColor = AppColors.darken(wishlistColor);
  final currentTheme = Theme.of(context);

  return currentTheme.copyWith(
    primaryColor: wishlistColor,
    primaryColorDark: wishlistDarkColor,
    appBarTheme: currentTheme.appBarTheme.copyWith(
      backgroundColor: wishlistColor,
    ),
    textSelectionTheme: currentTheme.textSelectionTheme.copyWith(
      cursorColor: wishlistColor,
      selectionHandleColor: wishlistColor,
      selectionColor: wishlistColor.withOpacity(0.3),
    ),
  );
}
