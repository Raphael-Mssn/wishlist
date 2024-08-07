import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wishlist/shared/theme/colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.style,
    this.isLoading = false,
  });

  final String text;
  final void Function() onPressed;
  final PrimaryButtonStyle style;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: style.padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
      ),
      onPressed: onPressed,
      child: isLoading
          ? Container(
              padding: const EdgeInsets.all(4),
              height: 40,
              width: 40,
              child: const CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          : Text(
              text,
              style: style.textStyle,
            ),
    );
  }
}

class PrimaryButtonStyle {
  const PrimaryButtonStyle({
    required this.textStyle,
    required this.padding,
  });

  final TextStyle textStyle;
  final EdgeInsets padding;

  static final small = PrimaryButtonStyle(
    textStyle: GoogleFonts.truculenta(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 6,
    ),
  );

  static final large = PrimaryButtonStyle(
    textStyle: GoogleFonts.truculenta(
      fontSize: 28,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: 32,
      vertical: 8,
    ),
  );
}
