import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/gen/assets.gen.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/widgets/dialogs/create_dialog.dart';
import 'package:wishlist/shared/widgets/page_layout_empty.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return PageLayoutEmpty(
      illustrationUrl: Assets.svg.noWishlist,
      title: l10n.noWishlist,
      callToAction: l10n.createButton,
      onCallToAction: () {
        showCreateDialog(context, ref);
      },
    );
  }
}
