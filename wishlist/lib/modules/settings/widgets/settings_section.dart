import 'package:flutter/material.dart';
import 'package:wishlist/modules/settings/widgets/settings_line.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<SettingsLine> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          title,
          style: AppTextStyles.smaller,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}
