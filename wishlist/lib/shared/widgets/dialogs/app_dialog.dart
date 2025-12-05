import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/utils/scaffold_messenger_extension.dart';

class _DialogLayout extends StatefulWidget {
  const _DialogLayout({
    required this.title,
    required this.content,
    required this.confirmLabel,
    this.onCancel,
    this.onConfirm,
    this.isConfirmEnabled,
  });

  final String title;
  final Widget content;
  final String confirmLabel;
  final void Function()? onCancel;
  final Future<void> Function()? onConfirm;
  final ValueListenable<bool>? isConfirmEnabled;

  @override
  State<_DialogLayout> createState() => _DialogLayoutState();
}

class _DialogLayoutState extends State<_DialogLayout> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final onCancel = widget.onCancel;
    final onConfirm = widget.onConfirm;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    Future<void> Function()? confirmHandler() {
      if (onConfirm == null || _isLoading) {
        return null;
      }
      return () async {
        setState(() {
          _isLoading = true;
        });
        try {
          await onConfirm();

          if (context.mounted && context.canPop()) {
            context.pop();
          }
        } catch (e) {
          if (context.mounted) {
            setState(() {
              _isLoading = false;
            });
            scaffoldMessenger.showGenericError();
          }
        }
      };
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        widget.title,
        style: AppTextStyles.titleSmall,
        textAlign: TextAlign.center,
      ),
      content: widget.content,
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [
            if (onCancel != null)
              SecondaryButton(
                style: BaseButtonStyle.medium,
                text: l10n.cancelButton,
                onPressed: () {
                  context.pop();
                  onCancel();
                },
              ),
            if (onConfirm != null)
              if (widget.isConfirmEnabled == null)
                PrimaryButton(
                  text: widget.confirmLabel,
                  onPressed: confirmHandler(),
                  style: BaseButtonStyle.medium,
                  isLoading: _isLoading,
                )
              else
                ValueListenableBuilder<bool>(
                  valueListenable: widget.isConfirmEnabled!,
                  builder: (context, enabled, child) {
                    return PrimaryButton(
                      text: widget.confirmLabel,
                      onPressed:
                          enabled && !_isLoading ? confirmHandler() : null,
                      style: BaseButtonStyle.medium,
                      isLoading: _isLoading,
                    );
                  },
                ),
          ],
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
  ValueListenable<bool>? isConfirmEnabled,
}) async {
  final l10n = context.l10n;
  final theme = Theme.of(context);

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
                context.pop();
              },
              child: AnimatedTheme(
                data: theme,
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
                        isConfirmEnabled: isConfirmEnabled,
                      ),
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
