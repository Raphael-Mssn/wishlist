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
  final void Function()? onPressed;
  final BaseButtonStyle style;
  final bool isLoading;
  final bool isStretched;

  Color backgroundColor(BuildContext context);

  Color textColor(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      style: style.textStyle.copyWith(
        color: textColor(context),
        fontWeight: FontWeight.bold,
      ),
    );

    return SizedBox(
      width: isStretched ? double.infinity : null,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor(context),
          disabledBackgroundColor: backgroundColor(context),
          disabledForegroundColor: textColor(context),
          padding: style.padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        onPressed: isLoading ? null : onPressed,
        child: IntrinsicHeight(
          child: Stack(
            children: [
              // Texte invisible pour maintenir la hauteur
              Opacity(
                opacity: 0,
                child: textWidget,
              ),
              // Contenu visible (texte ou loader)
              if (isLoading)
                Positioned.fill(
                  child: Center(
                    child: FittedBox(
                      child: CircularProgressIndicator(
                        color: textColor(context),
                      ),
                    ),
                  ),
                )
              else
                textWidget,
            ],
          ),
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

  @override
  Color textColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
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

  @override
  Color textColor(BuildContext context) {
    return AppColors.makara;
  }
}

class DangerButton extends BaseButton {
  const DangerButton({
    super.key,
    required super.text,
    required super.onPressed,
    required super.style,
    super.isLoading,
    super.isStretched,
  });

  @override
  Color backgroundColor(BuildContext context) {
    return AppColors.darkGrey;
  }

  @override
  Color textColor(BuildContext context) {
    return Colors.white;
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
      fontSize: 16,
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
      fontSize: 20,
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
      fontSize: 24,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    padding: EdgeInsets.symmetric(
      horizontal: 32,
      vertical: 8,
    ),
  );
}
