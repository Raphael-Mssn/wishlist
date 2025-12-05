import 'package:flutter/material.dart';
import 'package:wishlist/gen/fonts.gen.dart';
import 'package:wishlist/shared/theme/colors.dart';

// Flutter	        Figma
// FontWeight.w100	Thin
// FontWeight.w200	ExtraLight
// FontWeight.w300	Light
// FontWeight.w400	Regular
// FontWeight.w500	Medium
// FontWeight.w600	SemiBold
// FontWeight.w700	Bold
// FontWeight.w800	ExtraBold
// FontWeight.w900	Black

class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontFamily: FontFamily.plusJakartaSans,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.darkGrey,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: FontFamily.plusJakartaSans,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.darkGrey,
    height: 1,
  );

  static const large = TextStyle(
    fontFamily: FontFamily.plusJakartaSans,
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle medium = TextStyle(
    fontFamily: FontFamily.plusJakartaSans,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle small = TextStyle(
    fontFamily: FontFamily.plusJakartaSans,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle smaller = TextStyle(
    fontFamily: FontFamily.plusJakartaSans,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}
