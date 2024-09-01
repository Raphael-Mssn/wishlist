import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/friendship_status_provider.dart';
import 'package:wishlist/shared/infra/friendships_provider.dart';
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
  bool _isLoading = false;
  static const size = 32.0;
  static const iconColor = AppColors.background;

  Future<void> onPressed(FriendshipStatus status) async {
    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    final notifier = ref.read(friendshipsProvider.notifier);

    try {
      if (status == FriendshipStatus.none) {
        await notifier.askFriendship(widget.appUser);
      } else if (status == FriendshipStatus.pending) {
        await notifier.cancelFriendshipRequest(widget.appUser);
      }

      ref.invalidate(friendshipStatusProvider(widget.appUser.user.id));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncStatus =
        ref.watch(friendshipStatusProvider(widget.appUser.user.id));

    return asyncStatus.when(
      loading: _buildLoadingButton,
      error: (error, stackTrace) {
        // TODO: Handle error
        return const SizedBox();
      },
      data: (status) {
        return _buildButton(context, status);
      },
    );
  }

  Widget _buildLoadingButton() {
    return _buildButtonBase(
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

  Widget _buildButton(BuildContext context, FriendshipStatus status) {
    return _buildButtonBase(
      onPressed: () => onPressed(status),
      child: _isLoading
          ? const CircularProgressIndicator(
              color: iconColor,
              strokeWidth: 3,
            )
          : Icon(
              _getIconForStatus(status),
              color: iconColor,
              size: size,
            ),
    );
  }

  Widget _buildButtonBase({
    required VoidCallback onPressed,
    required Widget child,
  }) {
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

  IconData _getIconForStatus(FriendshipStatus status) {
    switch (status) {
      case FriendshipStatus.none:
        return Icons.person_add_alt_1;
      case FriendshipStatus.pending:
        return Icons.access_time_filled;
      case FriendshipStatus.accepted:
        return Icons.check;
      case FriendshipStatus.rejected:
      case FriendshipStatus.blocked:
        return Icons.block;
    }
  }
}
