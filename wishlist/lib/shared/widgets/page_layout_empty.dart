import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/primary_button.dart';

class PageLayoutEmpty extends StatelessWidget {
  const PageLayoutEmpty({
    super.key,
    required this.illustrationUrl,
    required this.title,
    required this.callToAction,
    required this.onCallToAction,
  });

  final String illustrationUrl;
  final String title;
  final String callToAction;
  final Function() onCallToAction;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: <Widget>[
            const Gap(64),
            SvgPicture.asset(
              illustrationUrl,
              height: MediaQuery.of(context).size.height / 2.5,
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
              style: PrimaryButtonStyle.large,
            ),
          ],
        ),
      ),
    );
  }
}
