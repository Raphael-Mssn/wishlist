import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/gen/assets.gen.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/friends/view/widgets/add_friend_bottom_sheet.dart';
import 'package:wishlist/modules/friends/view/widgets/friend_pill.dart';
import 'package:wishlist/modules/friends/view/widgets/user_pill.dart';
import 'package:wishlist/shared/infra/friendships_provider.dart';
import 'package:wishlist/shared/models/app_user.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/page_layout_empty/page_layout_empty.dart';
import 'package:wishlist/shared/utils/scaffold_messenger_extension.dart';
import 'package:wishlist/shared/widgets/page_layout.dart';

class FriendsScreen extends ConsumerWidget {
  const FriendsScreen({super.key});

  static const requestedType = 'requested';
  static const pendingType = 'pending';
  static const friendType = 'friend';

  List<_FriendItem> _buildCombinedList(FriendsData data) {
    final combinedList = <_FriendItem>[];

    combinedList.addAll(
      data.requestedFriends.map(
        (user) => _FriendItem(
          user: user,
          type: requestedType,
        ),
      ),
    );

    combinedList.addAll(
      data.pendingFriends.map(
        (user) => _FriendItem(
          user: user,
          type: pendingType,
        ),
      ),
    );

    combinedList.addAll(
      data.friends.map(
        (user) => _FriendItem(
          user: user,
          type: friendType,
        ),
      ),
    );

    return combinedList;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final friendsData = ref.watch(friendshipsProvider);

    Future<void> refreshFriends() async {
      await ref.read(friendshipsProvider.notifier).loadFriends();
    }

    return friendsData.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) {
        ScaffoldMessenger.of(context).showGenericError(isTopSnackBar: true);
        return const SizedBox.shrink();
      },
      data: (data) => data.isEmpty
          ? PageLayoutEmpty(
              illustrationUrl: Assets.svg.noFriend,
              title: l10n.noFriend,
              callToAction: l10n.addButton,
              onCallToAction: () => showAddFriendBottomSheet(context),
              onRefresh: refreshFriends,
              appBarTitle: l10n.fiendsScreenTitle,
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => SettingsRoute().push(context),
                ),
              ],
            )
          : PageLayout(
              title: l10n.fiendsScreenTitle,
              onRefresh: refreshFriends,
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => SettingsRoute().push(context),
                ),
              ],
              child: ListView.builder(
                itemCount: data.totalCount,
                itemBuilder: (context, index) {
                  final combinedList = _buildCombinedList(data);
                  final item = combinedList[index];
                  final isLastItem = index == combinedList.length - 1;

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: isLastItem ? 48 : 8,
                    ),
                    child: Builder(
                      builder: (context) {
                        switch (item.type) {
                          case requestedType:
                            return UserPill(
                              appUser: item.user,
                              isRequest: true,
                            );
                          case pendingType:
                            return UserPill(
                              appUser: item.user,
                            );
                          case friendType:
                            return FriendPill(appUser: item.user);
                          default:
                            return const SizedBox
                                .shrink(); // Should never happen
                        }
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class _FriendItem {
  _FriendItem({
    required this.user,
    required this.type,
  });
  final AppUser user;
  final String type;
}
