import 'package:flutter/material.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/theme.dart';

ThemeData getWishlistTheme(BuildContext? context, Wishlist wishlist) {
  final wishlistColor = AppColors.getColorFromHexValue(wishlist.color);
  final wishlistDarkColor = AppColors.darken(wishlistColor);

  final currentTheme = context != null ? Theme.of(context) : theme;

  return currentTheme.copyWith(
    primaryColor: wishlistColor,
    primaryColorDark: wishlistDarkColor,
    appBarTheme: currentTheme.appBarTheme.copyWith(
      backgroundColor: wishlistColor,
    ),
    textSelectionTheme: currentTheme.textSelectionTheme.copyWith(
      cursorColor: wishlistColor,
      selectionHandleColor: wishlistColor,
      selectionColor: wishlistColor.withValues(alpha: 0.3),
    ),
  );
}
