import 'package:flutter/material.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/widgets/dialogs/app_dialog.dart';

class _ConfirmDialogContent extends StatelessWidget {
  const _ConfirmDialogContent({
    required this.explanation,
  });

  final String explanation;

  @override
  Widget build(BuildContext context) {
    return Text(
      explanation,
      style: AppTextStyles.small.copyWith(
        color: AppColors.makara,
      ),
    );
  }
}

Future<void> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String explanation,
  required Future<void> Function()? onConfirm,
}) async {
  final l10n = context.l10n;

  return showAppDialog(
    context,
    title: title,
    content: _ConfirmDialogContent(
      explanation: explanation,
    ),
    confirmButtonLabel: l10n.confirmDialogConfirmButtonLabel,
    onConfirm: onConfirm,
    onCancel: () {},
  );
}
