import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/widgets/dialogs/app_dialog.dart';

class _CreateDialogContent extends StatelessWidget {
  const _CreateDialogContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const labelFontSize = 20.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListBody(
          children: <Widget>[
            TextField(
              style: GoogleFonts.truculenta(fontSize: labelFontSize),
              cursorColor: AppColors.primary,
              autofocus: true,
              decoration: InputDecoration(
                hintText: l10n.name,
                hintStyle: GoogleFonts.truculenta(
                  fontSize: labelFontSize,
                  fontStyle: FontStyle.italic,
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Future<void> showCreateDialog(BuildContext context) async {
  final l10n = context.l10n;

  return showAppDialog(
    context,
    title: l10n.createWishlist,
    content: const _CreateDialogContent(),
    confirmButtonLabel: l10n.createButton,
    onConfirm: () {},
    onCancel: () {},
  );
}
