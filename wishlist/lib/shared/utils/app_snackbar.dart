import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart' as tsb;
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

enum SnackBarType {
  success,
  error,
}

/// Affiche un snackbar avec un style moderne
///
/// Exemples :
/// ```dart
/// // Succès
/// showAppSnackBar(
///   context,
///   'Opération réussie',
///   type: SnackBarType.success,
/// );
///
/// // Erreur
/// showAppSnackBar(
///   context,
///   'Une erreur est survenue',
///   type: SnackBarType.error,
/// );
/// ```
void showAppSnackBar(
  BuildContext context,
  String message, {
  required SnackBarType type,
  bool isTopSnackBar = false,
  Duration duration = const Duration(seconds: 4),
}) {
  final indicatorColor =
      type == SnackBarType.success ? Colors.green : Colors.red;

  final icon = type == SnackBarType.success
      ? Icons.check_circle_outline
      : Icons.error_outline;

  final overlay = Overlay.of(context, rootOverlay: true);

  tsb.showTopSnackBar(
    overlay,
    _AppSnackBarContent(
      message: message,
      icon: icon,
      iconColor: indicatorColor,
      textColor: Colors.black87,
      duration: duration,
    ),
    displayDuration: duration,
    animationDuration: const Duration(milliseconds: 400),
    reverseAnimationDuration: const Duration(milliseconds: 400),
    dismissType: tsb.DismissType.onSwipe,
    dismissDirection: const [DismissDirection.horizontal],
    snackBarPosition:
        isTopSnackBar ? tsb.SnackBarPosition.top : tsb.SnackBarPosition.bottom,
  );
}

/// Affiche une erreur générique
void showGenericError(
  BuildContext context, {
  bool isTopSnackBar = false,
  Duration duration = const Duration(seconds: 4),
}) {
  showAppSnackBar(
    context,
    context.l10n.genericError,
    type: SnackBarType.error,
    isTopSnackBar: isTopSnackBar,
    duration: duration,
  );
}

class _AppSnackBarContent extends StatefulWidget {
  const _AppSnackBarContent({
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.textColor,
    required this.duration,
  });

  final String message;
  final IconData icon;
  final Color iconColor;
  final Color textColor;
  final Duration duration;

  @override
  State<_AppSnackBarContent> createState() => _AppSnackBarContentState();
}

class _AppSnackBarContentState extends State<_AppSnackBarContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const radius = 8.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: radius,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  color: widget.iconColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.message,
                    style: AppTextStyles.smaller.copyWith(
                      color: widget.textColor,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius),
                ),
                child: LinearProgressIndicator(
                  value: 1 - _controller.value,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(widget.iconColor),
                  minHeight: 3,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
