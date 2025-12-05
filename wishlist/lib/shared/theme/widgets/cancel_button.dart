import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishlist/gen/fonts.gen.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({super.key, required this.text, required this.onPressed});

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: FontFamily.plusJakartaSans,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      onPressed: () {
        context.pop();
      },
    );
  }
}
