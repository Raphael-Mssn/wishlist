import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/friendship_mutations_provider.dart';
import 'package:wishlist/shared/infra/friendship_status_provider.dart';
import 'package:wishlist/shared/models/app_user.dart';
import 'package:wishlist/shared/models/friendship/friendship.dart';
import 'package:wishlist/shared/theme/colors.dart';

class AskFriendshipButton extends ConsumerStatefulWidget {
  const AskFriendshipButton({
    super.key,
    required this.appUser,
  });

  final AppUser appUser;

  @override
  ConsumerState<AskFriendshipButton> createState() =>
      _AskFriendshipButtonState();
}

class _AskFriendshipButtonState extends ConsumerState<AskFriendshipButton> {
  FriendshipStatus? _optimisticStatus;

  Future<void> onPressed(FriendshipStatus status) async {
    final mutations = ref.read(friendshipMutationsProvider.notifier);

    try {
      if (status == FriendshipStatus.none) {
        setState(() => _optimisticStatus = FriendshipStatus.pending);
        await mutations.askFriendship(widget.appUser.user.id);
      } else if (status == FriendshipStatus.pending) {
        setState(() => _optimisticStatus = FriendshipStatus.none);
        await mutations.cancelFriendshipRequest(widget.appUser.user.id);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _optimisticStatus = null);
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncStatus =
        ref.watch(friendshipStatusProvider(widget.appUser.user.id));

    // Quand Realtime propage le changement, on retire l'optimistic status
    ref.listen(
      friendshipStatusProvider(widget.appUser.user.id),
      (previous, next) {
        if (_optimisticStatus != null && mounted) {
          setState(() => _optimisticStatus = null);
        }
      },
    );

    return asyncStatus.when(
      loading: () => const _LoadingButton(),
      error: (error, stackTrace) {
        // TODO: Handle error
        return const SizedBox();
      },
      data: (status) {
        // Utiliser l'optimistic status si disponible, sinon le status réel
        final displayStatus = _optimisticStatus ?? status;
        return _StatusButton(
          status: displayStatus,
          onPressed: onPressed,
        );
      },
    );
  }
}

class _LoadingButton extends StatelessWidget {
  const _LoadingButton();

  static const Color iconColor = AppColors.background;

  @override
  Widget build(BuildContext context) {
    return _ButtonBase(
      onPressed: () {},
      child: const Padding(
        padding: EdgeInsets.all(4),
        child: CircularProgressIndicator(
          color: iconColor,
          strokeWidth: 3,
        ),
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  const _StatusButton({
    required this.status,
    required this.onPressed,
  });

  final FriendshipStatus status;
  final Function(FriendshipStatus) onPressed;

  static const Color iconColor = AppColors.background;

  @override
  Widget build(BuildContext context) {
    return _ButtonBase(
      onPressed: () => onPressed(status),
      child: Icon(
        _getIconForStatus(status),
        color: iconColor,
        size: _ButtonBase.size,
      ),
    );
  }

  IconData _getIconForStatus(FriendshipStatus status) {
    switch (status) {
      case FriendshipStatus.none:
        return Icons.person_add_alt_1;
      case FriendshipStatus.pending:
        return Icons.access_time_filled;
      case FriendshipStatus.accepted:
        return Icons.check;
    }
  }
}

class _ButtonBase extends StatelessWidget {
  const _ButtonBase({
    required this.onPressed,
    required this.child,
  });

  final VoidCallback onPressed;
  final Widget child;

  static const double size = 32;
  static const Color iconColor = AppColors.background;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: iconColor,
        backgroundColor: AppColors.makara,
      ),
      onPressed: onPressed,
      child: SizedBox.square(
        dimension: size,
        child: Center(child: child),
      ),
    );
  }
}
