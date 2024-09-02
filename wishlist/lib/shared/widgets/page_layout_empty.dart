import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/app_refresh_indicator.dart';
import 'package:wishlist/shared/theme/widgets/primary_button.dart';

class PageLayoutEmpty extends StatelessWidget {
  const PageLayoutEmpty({
    super.key,
    required this.illustrationUrl,
    required this.title,
    required this.callToAction,
    required this.onCallToAction,
    this.onRefresh,
  });

  final String illustrationUrl;
  final String title;
  final String callToAction;
  final Function() onCallToAction;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final onRefresh = this.onRefresh;

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
        const Spacer(),
      ],
    );

    return SafeArea(
      child: onRefresh != null
          ? AppRefreshIndicator(
              onRefresh: onRefresh,
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: constraints.maxHeight,
                        child: content,
                      ),
                    );
                  },
                ),
              ),
            )
          : Center(child: content),
    );
  }
}
