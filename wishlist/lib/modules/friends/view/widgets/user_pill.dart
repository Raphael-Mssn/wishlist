import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/modules/friends/view/widgets/accept_or_decline_friendship_button.dart';
import 'package:wishlist/modules/friends/view/widgets/ask_friendship_button.dart';
import 'package:wishlist/modules/friends/view/widgets/base_avatar_pill.dart';
import 'package:wishlist/shared/infra/friendship_actions_provider.dart';
import 'package:wishlist/shared/models/app_user.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

class UserPill extends ConsumerWidget {
  const UserPill({
    super.key,
    required this.appUser,
    this.isRequest = false,
  });

  final AppUser appUser;
  final bool isRequest;

  Future<void> _onAccept(WidgetRef ref) async =>
      ref.read(friendshipActionsProvider).acceptFriendship(appUser.user.id);

  Future<void> _onDecline(WidgetRef ref) async =>
      ref.read(friendshipActionsProvider).declineFriendship(appUser.user.id);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttons = isRequest
        ? <Widget>[
            AcceptOrDeclineFriendshipButton(
              onAccept: () => _onAccept(ref),
              onDecline: () => _onDecline(ref),
            ),
          ]
        : <Widget>[
            AskFriendshipButton(
              appUser: appUser,
            ),
          ];

    return BaseAvatarPill(
      onTap: null,
      backgroundColor: AppColors.gainsboro,
      avatarBorderColor: AppColors.pastelGray,
      avatarUrl: appUser.profile.avatarUrl,
      userId: appUser.user.id,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              appUser.profile.pseudo,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.small.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.darkGrey,
              ),
            ),
          ),
          ...buttons,
        ],
      ),
    );
  }
}
