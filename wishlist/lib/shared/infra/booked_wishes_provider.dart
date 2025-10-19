import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_repository_provider.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/models/booked_wish_with_details/booked_wish_with_details.dart';

class BookedWishesNotifier
    extends StateNotifier<AsyncValue<IList<BookedWishWithDetails>>> {
  BookedWishesNotifier(this._wishRepository, this._userService)
      : super(const AsyncValue.loading()) {
    loadBookedWishes();
  }

  final _wishRepository;
  final UserService _userService;

  Future<void> loadBookedWishes() async {
    state = const AsyncValue.loading();
    try {
      final userId = _userService.getCurrentUserId();
      final bookedWishes = await _wishRepository.getBookedWishesByUser(userId);
      state = AsyncValue.data(bookedWishes);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final bookedWishesProvider = StateNotifierProvider<BookedWishesNotifier,
    AsyncValue<IList<BookedWishWithDetails>>>((ref) {
  return BookedWishesNotifier(
    ref.watch(wishRepositoryProvider),
    ref.watch(userServiceProvider),
  );
});
