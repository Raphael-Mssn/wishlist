import 'package:flutter/material.dart';
import 'package:wishlist/shared/page_layout_empty/page_layout_empty_content.dart';
import 'package:wishlist/shared/theme/widgets/app_refresh_indicator.dart';

class PageLayoutEmpty extends StatelessWidget {
  const PageLayoutEmpty({
    super.key,
    required this.illustrationUrl,
    this.illustrationHeight,
    required this.title,
    required this.callToAction,
    required this.onCallToAction,
    this.onRefresh,
  });

  final String illustrationUrl;
  final double? illustrationHeight;
  final String title;
  final String callToAction;
  final Function() onCallToAction;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final onRefresh = this.onRefresh;
    final illustrationHeight =
        this.illustrationHeight ?? MediaQuery.sizeOf(context).height / 2.5;

    final content = Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 64),
        child: PageLayoutEmptyContent(
          illustrationUrl: illustrationUrl,
          illustrationHeight: illustrationHeight,
          title: title,
          callToAction: callToAction,
          onCallToAction: onCallToAction,
        ),
      ),
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
          : content,
    );
  }
}
