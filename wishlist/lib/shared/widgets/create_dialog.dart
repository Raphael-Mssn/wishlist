import 'package:flutter/material.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateDialog extends StatelessWidget {
  final Animation<double> animation;

  const CreateDialog({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            l10n.create_new_wishlist,
            style: GoogleFonts.truculenta(
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListBody(
                  children: <Widget>[
                    TextField(
                      style: GoogleFonts.truculenta(fontSize: 20),
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        hintText: l10n.wishlist_name,
                        hintStyle: GoogleFonts.truculenta(
                            fontSize: 20, fontStyle: FontStyle.italic),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    // Ajoutez d'autres champs de formulaire ici si nécessaire
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.cancel_button,
                  style: GoogleFonts.truculenta(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Traitez les données du formulaire ici
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                l10n.create_button,
                style: GoogleFonts.truculenta(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ],
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        );
      },
    );
  }
}
