import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/theme/widgets/cancel_button.dart';
import 'package:wishlist/shared/theme/widgets/primary_button.dart';

class CreateDialog extends StatelessWidget {
  const CreateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const labelFontSize = 20.0;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        l10n.create_wishlist,
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
                cursorColor: Theme.of(context).primaryColor,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.name,
                  hintStyle: GoogleFonts.truculenta(
                    fontSize: labelFontSize,
                    fontStyle: FontStyle.italic,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        CancelButton(
          text: l10n.cancel_button,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        PrimaryButton(
          text: l10n.create_button,
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: PrimaryButtonStyle.small,
        ),
      ],
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}

Future<void> showCreateDialog(BuildContext context) async {
  final l10n = context.l10n;

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: l10n.close_dialog,
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
          return const CreateDialog();
        },
      );
    },
  );
}
