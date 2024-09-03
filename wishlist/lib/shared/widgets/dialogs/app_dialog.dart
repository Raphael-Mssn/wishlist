import 'package:flutter/material.dart';
import 'package:wishlist/gen/fonts.gen.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/infra/utils/scaffold_messenger_extension.dart';
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
  final Future<void> Function()? onConfirm;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final onCancel = this.onCancel;
    final onConfirm = this.onConfirm;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: FontFamily.truculenta,
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
              navigator.pop();
              onCancel();
            },
          ),
        if (onConfirm != null)
          PrimaryButton(
            text: confirmLabel,
            onPressed: () async {
              try {
                await onConfirm();

                if (navigator.canPop()) {
                  navigator.pop();
                }
              } catch (e) {
                if (context.mounted) {
                  scaffoldMessenger.showGenericError(
                    context,
                  );
                }
              }
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
  Future<void> Function()? onConfirm,
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
      return ScaffoldMessenger(
        child: Builder(
          builder: (context) => Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              // Enable dialog closing on outside click
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: GestureDetector(
                    // Disable dialog closing on dialog click
                    onTap: () {},
                    child: _DialogLayout(
                      title: title,
                      content: content,
                      confirmLabel: confirmButtonLabel,
                      onConfirm: onConfirm,
                      onCancel: onCancel,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
