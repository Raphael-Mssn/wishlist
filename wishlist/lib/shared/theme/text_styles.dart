import 'package:flutter/material.dart';
import 'package:wishlist/gen/fonts.gen.dart';

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
    fontFamily: FontFamily.truculenta,
    fontSize: 32,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle medium = TextStyle(
    fontFamily: FontFamily.truculenta,
    fontSize: 26,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle small = TextStyle(
    fontFamily: FontFamily.truculenta,
    fontSize: 22,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle smaller = TextStyle(
    fontFamily: FontFamily.truculenta,
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );
}
