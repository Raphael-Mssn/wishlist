import 'package:flutter/material.dart';

class DefaultAvatarIcon extends StatelessWidget {
  const DefaultAvatarIcon({
    super.key,
    this.size = 64.0,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.account_circle,
      size: size,
      color: color,
    );
  }
}
