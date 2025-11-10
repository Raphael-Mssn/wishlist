import 'package:flutter/material.dart';
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

  final overlayState = Overlay.of(context, rootOverlay: true);

  late final OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => _AnimatedSnackBar(
      message: message,
      icon: icon,
      iconColor: indicatorColor,
      duration: duration,
      isTop: isTopSnackBar,
      onDismissed: () {
        overlayEntry.remove();
      },
    ),
  );

  overlayState.insert(overlayEntry);
}

/// Affiche une erreur générique
void showGenericError(
  BuildContext context, {
  bool isTopSnackBar = false,
  Duration duration = const Duration(seconds: 4),
}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    showAppSnackBar(
      context,
      context.l10n.genericError,
      type: SnackBarType.error,
      isTopSnackBar: isTopSnackBar,
      duration: duration,
    );
  });
}

/// Widget qui gère l'animation d'entrée/sortie et la progress bar du snackbar
class _AnimatedSnackBar extends StatefulWidget {
  const _AnimatedSnackBar({
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.duration,
    required this.isTop,
    required this.onDismissed,
  });

  final String message;
  final IconData icon;
  final Color iconColor;
  final Duration duration;
  final bool isTop;
  final VoidCallback onDismissed;

  @override
  State<_AnimatedSnackBar> createState() => _AnimatedSnackBarState();
}

class _AnimatedSnackBarState extends State<_AnimatedSnackBar>
    with TickerProviderStateMixin {
  late final AnimationController _slideController;
  late final AnimationController _progressController;
  late final Animation<Offset> _slideAnimation;
  late final Key _dismissibleKey;

  @override
  void initState() {
    super.initState();
    _dismissibleKey = ValueKey(DateTime.now().millisecondsSinceEpoch);

    // Animation d'entrée/sortie
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.isTop ? -1.5 : 1.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.elasticOut,
        reverseCurve: Curves.easeInCubic,
      ),
    );

    // Animation de la progress bar (1.0 -> 0.0)
    _progressController = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: 1,
    );

    // Démarrer les animations
    _slideController.forward();
    _progressController.reverse().then((_) {
      if (mounted) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  /// Déclenche l'animation de sortie automatique
  void _dismiss() {
    if (!mounted) {
      return;
    }

    _slideController.duration = const Duration(milliseconds: 300);
    _slideController.reverse().then((_) {
      if (mounted) {
        widget.onDismissed();
      }
    });
  }

  /// Gère le dismiss manuel par swipe
  void _handleDismiss(DismissDirection direction) {
    _progressController.stop();
    widget.onDismissed();
  }

  /// Gère le dismiss manuel par tap
  void _handleTap() {
    _progressController.stop();
    _dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: SafeArea(
        child: Align(
          alignment:
              widget.isTop ? Alignment.topCenter : Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Dismissible(
              key: _dismissibleKey,
              onDismissed: _handleDismiss,
              dismissThresholds: const {
                DismissDirection.startToEnd: 0.3,
                DismissDirection.endToStart: 0.3,
              },
              child: GestureDetector(
                onTap: _handleTap,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) => _AppSnackBarContent(
                      message: widget.message,
                      icon: widget.icon,
                      iconColor: widget.iconColor,
                      progress: _progressController.value,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppSnackBarContent extends StatelessWidget {
  const _AppSnackBarContent({
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.progress,
  });

  final String message;
  final IconData icon;
  final Color iconColor;
  final double progress;

  @override
  Widget build(BuildContext context) {
    const radius = 8.0;

    return DecoratedBox(
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
                  icon,
                  color: iconColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: AppTextStyles.smaller.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(radius),
              bottomRight: Radius.circular(radius),
            ),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity().scaledByDouble(-1, -1, 1, 1),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                minHeight: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
