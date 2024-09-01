import 'package:flutter/widgets.dart';
import 'package:wishlist/shared/theme/colors.dart';

class BaseAvatarPill extends StatelessWidget {
  const BaseAvatarPill({
    super.key,
    required this.backgroundColor,
    required this.avatarBorderColor,
    required this.child,
  });

  final Color backgroundColor;
  final Color avatarBorderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(50),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(
                    BorderSide(
                      color: avatarBorderColor,
                      width: 6,
                    ),
                  ),
                ),
                child: // TODO: Add avatar
                    const SizedBox.shrink(),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
