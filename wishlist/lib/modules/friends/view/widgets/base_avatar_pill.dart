import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/widgets/app_wave_pattern.dart';
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
  final VoidCallback? onTap;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const avatarSize = 64.0;
    const borderRadius = BorderRadius.all(
      Radius.circular(50),
    );
    final avatarUrl = this.avatarUrl;
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

    final boxDecorationColor =
        hasAvatar ? AppColors.background : AppColors.makara;

    return AppWavePattern(
      backgroundColor: backgroundColor,
      preset: WavePreset.pill,
      rotationType: WaveRotationType.fixed,
      rotationAngle: 45,
      borderRadius: borderRadius,
      height: avatarSize,
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Container(
            height: avatarSize,
            width: avatarSize,
            decoration: BoxDecoration(
              color: boxDecorationColor,
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
    );
  }
}
