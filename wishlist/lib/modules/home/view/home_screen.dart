import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/theme/widgets/app_scaffold.dart';
import 'package:wishlist/shared/theme/widgets/primary_button.dart';
import 'package:wishlist/shared/widgets/floating_nav_bar.dart';
import 'package:wishlist/shared/widgets/nav_bar_add_button.dart';
import 'package:wishlist/shared/widgets/create_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppScaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              const Gap(64),
              SvgPicture.asset(
                'assets/svg/no_wishlist.svg',
              ),
              const Gap(32),
              Text(
                l10n.no_wishlist,
                style: GoogleFonts.truculenta(
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(16),
              PrimaryButton(
                text: l10n.create_button,
                onPressed: () {
                  _showCreateDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: NavBarAddButton(
        onPressed: () {
          _showCreateDialog(context);
        },
      ),
      bottomNavigationBar: const FloatingNavBar(),
    );
  }

  Future<void> _showCreateDialog(BuildContext context) async {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '', // Combinaison barrierDismissible: true et barrierLabel != null pour pouvoir fermer le dialog en cliquant ailleurs
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
        return CreateDialog(animation: animation);
      },
    );
  }
}
