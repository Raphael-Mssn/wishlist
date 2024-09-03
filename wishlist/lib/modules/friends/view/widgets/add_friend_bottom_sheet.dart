import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/friends/view/infra/search_notifier.dart';
import 'package:wishlist/modules/friends/view/widgets/user_pill.dart';
import 'package:wishlist/modules/friends/view/widgets/user_search_bar.dart';
import 'package:wishlist/shared/infra/utils/debouncer.dart';
import 'package:wishlist/shared/infra/utils/scaffold_messenger_extension.dart';
import 'package:wishlist/shared/theme/colors.dart';

class AddFriendBottomSheet extends ConsumerStatefulWidget {
  const AddFriendBottomSheet({super.key});

  @override
  ConsumerState<AddFriendBottomSheet> createState() =>
      _AddFriendBottomSheetState();
}

class _AddFriendBottomSheetState extends ConsumerState<AddFriendBottomSheet> {
  final _searchBarController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();

    _searchBarController.addListener(
      () {
        _debouncer.run(() {
          ref.read(searchProvider.notifier).search(_searchBarController.text);
        });
      },
    );
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const itemPadding = EdgeInsets.symmetric(vertical: 4);
    final lastItemPadding = itemPadding.copyWith(bottom: 48);
    final searchState = ref.watch(searchProvider);

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                UserSearchBar(
                  controller: _searchBarController,
                ),
                const Gap(20),
                searchState.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stackTrace) {
                    ScaffoldMessenger.of(context).showGenericError(context);
                    return const SizedBox.shrink();
                  },
                  data: (users) {
                    if (users.isEmpty) {
                      return Text(
                        context.l10n.noUserFound,
                      );
                    }
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final isLast = index == users.length - 1;
                        final appUser = users[index];

                        return Padding(
                          padding: isLast ? lastItemPadding : itemPadding,
                          child: UserPill(
                            appUser: appUser,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showAddFriendBottomSheet(BuildContext context) {
  const radius = Radius.circular(20);

  showBarModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.background,
    expand: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: radius,
        topRight: radius,
      ),
    ),
    builder: (context) {
      return const Scaffold(body: AddFriendBottomSheet());
    },
  );
}
