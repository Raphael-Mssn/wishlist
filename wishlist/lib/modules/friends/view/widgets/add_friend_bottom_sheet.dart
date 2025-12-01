import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/friends/view/infra/search_notifier.dart';
import 'package:wishlist/modules/friends/view/widgets/user_pill.dart';
import 'package:wishlist/modules/friends/view/widgets/user_search_bar.dart';
import 'package:wishlist/shared/infra/utils/debouncer.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/widgets/app_bottom_sheet.dart';

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
    final searchState = ref.watch(searchProvider);
    const paddingValue = 30.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(paddingValue).copyWith(bottom: 0),
          child: Column(
            children: [
              UserSearchBar(
                controller: _searchBarController,
              ),
              const Gap(20),
              searchState.when(
                loading: () => const CircularProgressIndicator(),
                error: (error, stackTrace) {
                  showGenericError(context);
                  return const SizedBox.shrink();
                },
                data: (users) {
                  if (users.isEmpty) {
                    return Text(
                      context.l10n.noUserFound,
                    );
                  }
                  return Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: paddingValue),
                      itemBuilder: (context, index) => UserPill(
                        appUser: users[index],
                      ),
                      separatorBuilder: (context, index) => const Gap(4),
                      itemCount: users.length,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showAddFriendBottomSheet(BuildContext context) {
  showAppBottomSheet(
    context,
    body: const AddFriendBottomSheet(),
  );
}
