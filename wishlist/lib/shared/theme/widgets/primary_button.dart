import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.style,
  });

  final String text;
  final void Function() onPressed;
  final PrimaryButtonStyle style;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        padding: style.padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
      ),
      onPressed: onPressed,
      child: Text(
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
