import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';

class PageLayoutEmptyContent extends StatelessWidget {
  const PageLayoutEmptyContent({
    super.key,
    required this.illustrationUrl,
    required this.illustrationHeight,
    required this.title,
    required this.callToAction,
    required this.onCallToAction,
  });

  final String illustrationUrl;
  final double illustrationHeight;
  final String title;
  final String callToAction;
  final Function() onCallToAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SvgPicture.asset(
          illustrationUrl,
          height: illustrationHeight,
        ),
        const Gap(32),
        Text(
          title,
          style: AppTextStyles.title,
        ),
        const Gap(16),
        PrimaryButton(
          text: callToAction,
          onPressed: onCallToAction,
          style: BaseButtonStyle.large,
        ),
      ],
    );
  }
}
