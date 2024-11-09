import 'package:flutter/material.dart';
import 'package:wishlist/l10n/l10n.dart';

extension ScaffoldMessengerExtension on ScaffoldMessengerState {
  void showTopSnackBar(
    Widget content,
  ) {
    final snackBar = SnackBar(
      content: content,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.sizeOf(context).height -
            MediaQuery.viewPaddingOf(context).top -
            130,
        left: 10,
        right: 10,
      ),
    );

    // Remove the current snackbar if any, then show the new one
    removeCurrentSnackBar();

    showSnackBar(snackBar);
  }

  void showGenericError({
    bool isTopSnackBar = false,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final content = Text(context.l10n.genericError);

      if (isTopSnackBar) {
        showTopSnackBar(content);
      } else {
        showSnackBar(SnackBar(content: content));
      }
    });
  }
}
