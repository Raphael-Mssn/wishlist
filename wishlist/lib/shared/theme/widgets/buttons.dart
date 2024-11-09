import 'package:flutter/material.dart';
import 'package:wishlist/gen/fonts.gen.dart';
import 'package:wishlist/shared/theme/colors.dart';

abstract class BaseButton extends StatelessWidget {
  const BaseButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.style,
    this.isLoading = false,
    this.isStretched = false,
  });

  final String text;
  final void Function() onPressed;
  final BaseButtonStyle style;
  final bool isLoading;
  final bool isStretched;

  Color backgroundColor(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isStretched ? double.infinity : null,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor(context),
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
      ),
    );
  }
}

class PrimaryButton extends BaseButton {
  const PrimaryButton({
    super.key,
    required super.text,
    required super.onPressed,
    required super.style,
    super.isLoading,
    super.isStretched,
  });

  @override
  Color backgroundColor(BuildContext context) {
    return Theme.of(context).primaryColor;
  }
}

class SecondaryButton extends BaseButton {
  const SecondaryButton({
    super.key,
    required super.text,
    required super.onPressed,
    required super.style,
    super.isLoading,
    super.isStretched,
  });

  @override
  Color backgroundColor(BuildContext context) {
    return AppColors.pastelGray;
  }
}

class BaseButtonStyle {
  const BaseButtonStyle({
    required this.textStyle,
    required this.padding,
  });

  final TextStyle textStyle;
  final EdgeInsets padding;

  static const small = BaseButtonStyle(
    textStyle: TextStyle(
      fontFamily: FontFamily.truculenta,
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    padding: EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 6,
    ),
  );

  static const medium = BaseButtonStyle(
    textStyle: TextStyle(
      fontFamily: FontFamily.truculenta,
      fontSize: 24,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    padding: EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
  );

  static const large = BaseButtonStyle(
    textStyle: TextStyle(
      fontFamily: FontFamily.truculenta,
      fontSize: 28,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    padding: EdgeInsets.symmetric(
      horizontal: 32,
      vertical: 8,
    ),
  );
}
