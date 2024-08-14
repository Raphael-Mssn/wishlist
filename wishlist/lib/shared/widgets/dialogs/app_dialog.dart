import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/widgets/cancel_button.dart';
import 'package:wishlist/shared/theme/widgets/primary_button.dart';

class _DialogLayout extends StatelessWidget {
  const _DialogLayout({
    required this.title,
    required this.content,
    required this.confirmLabel,
    this.onCancel,
    this.onConfirm,
  });

  final String title;
  final Widget content;
  final String confirmLabel;
  final void Function()? onCancel;
  final void Function()? onConfirm;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final onCancel = this.onCancel;
    final onConfirm = this.onConfirm;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        title,
        style: GoogleFonts.truculenta(
          fontSize: 28,
          fontWeight: FontWeight.w500,
        ),
      ),
      content: content,
      actions: <Widget>[
        if (onCancel != null)
          CancelButton(
            text: l10n.cancelButton,
            onPressed: () {
              Navigator.of(context).pop();
              onCancel();
            },
          ),
        if (onConfirm != null)
          PrimaryButton(
            text: confirmLabel,
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            style: PrimaryButtonStyle.small,
          ),
      ],
      backgroundColor: AppColors.background,
    );
  }
}

Future<void> showAppDialog(
  BuildContext context, {
  required String title,
  required Widget content,
  required String confirmButtonLabel,
  void Function()? onConfirm,
  void Function()? onCancel,
}) async {
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
          return _DialogLayout(
            title: title,
            content: content,
            confirmLabel: confirmButtonLabel,
            onConfirm: onConfirm,
            onCancel: onCancel,
          );
        },
      );
    },
  );
}
