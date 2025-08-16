import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pattern_box/pattern_box.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/widgets/angled_wave_painter.dart';
import 'package:wishlist/shared/theme/widgets/rotatable_pattern_box.dart';
import 'package:wishlist/shared/widgets/avatar/app_avatar.dart';

class BaseAvatarPill extends ConsumerWidget {
  const BaseAvatarPill({
    super.key,
    required this.backgroundColor,
    required this.avatarBorderColor,
    required this.child,
    required this.onTap,
    this.avatarUrl,
  });

  final Color backgroundColor;
  final Color avatarBorderColor;
  final Widget child;
  final void Function(BuildContext) onTap;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const avatarSize = 64.0;
    const borderRadius = BorderRadius.all(
      Radius.circular(50),
    );

    return InkWell(
      onTap: () => onTap(context),
      borderRadius: borderRadius,
      highlightColor: AppColors.darken(backgroundColor),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: backgroundColor,
        ),
        child: PatternBoxWidget(
          height: avatarSize,
          pattern: WavePainter(
            frequency: 0.8,
            thickness: 12,
            gap: 42,
            color: AppColors.lighten(backgroundColor),
            amplitude: 80,
          )
              .withAngleVariation(
                angleVariation: 0.2,
              )
              .rotatedDegrees(
                45,
              ),
          borderRadius: borderRadius,
          child: Row(
            children: <Widget>[
              Container(
                height: avatarSize,
                width: avatarSize,
                decoration: BoxDecoration(
                  color: AppColors.makara,
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(
                    BorderSide(
                      color: avatarBorderColor,
                      width: 6,
                    ),
                  ),
                ),
                child: AppAvatar(
                  avatarUrl: avatarUrl,
                  size: avatarSize - 12,
                  hasBorders: false,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
