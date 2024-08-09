import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  static TextStyle title = GoogleFonts.truculenta(
    fontSize: 36,
    fontWeight: FontWeight.w500,
  );

  static TextStyle smaller = GoogleFonts.truculenta(
    fontSize: 22,
    fontWeight: FontWeight.w400,
  );
}
