import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/non_null_extensions/go_true_client_non_null_getter_user_extension.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/models/app_user.dart';

class SearchNotifier extends StateNotifier<AsyncValue<IList<AppUser>>> {
  SearchNotifier(this.ref) : super(const AsyncValue.data(IList.empty()));

  final Ref ref;

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data(IList.empty());
      return;
    }

    state = const AsyncValue.loading();
    try {
      final appUsers =
          await ref.read(userServiceProvider).searchUsersByEmailOrPseudo(query);
      final appUsersWithoutCurrentUser = appUsers
          .where(
            (appUser) =>
                appUser.user.id !=
                ref.read(supabaseClientProvider).auth.currentUserNonNull.id,
          )
          .toIList();

      state = AsyncValue.data(appUsersWithoutCurrentUser);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final searchProvider = StateNotifierProvider.autoDispose<SearchNotifier,
    AsyncValue<IList<AppUser>>>((ref) {
  return SearchNotifier(ref);
});
