import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/widgets/cancel_button.dart';
import 'package:wishlist/shared/theme/widgets/primary_button.dart';

class _CreateDialog extends StatelessWidget {
  const _CreateDialog();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const labelFontSize = 20.0;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        l10n.createWishlist,
        style: GoogleFonts.truculenta(
          fontSize: 28,
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Column(
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
      ),
      actions: <Widget>[
        CancelButton(
          text: l10n.cancelButton,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        PrimaryButton(
          text: l10n.createButton,
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: PrimaryButtonStyle.small,
        ),
      ],
      backgroundColor: AppColors.background,
    );
  }
}

Future<void> showCreateDialog(BuildContext context) async {
  final l10n = context.l10n;

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: l10n.closeDialog,
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      );
      return ScaleTransition(
        scale: curvedAnimation,
        child: child,
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return const _CreateDialog();
        },
      );
    },
  );
}
