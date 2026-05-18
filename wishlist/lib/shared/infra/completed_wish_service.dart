import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/repositories/user_completed_wish/user_completed_wish_repository.dart';
import 'package:wishlist/shared/infra/repositories/user_completed_wish/user_completed_wish_repository_provider.dart';
import 'package:wishlist/shared/infra/user_service.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

class CompletedWishService {
  CompletedWishService(this._repository, this._userService);

  final UserCompletedWishRepository _repository;
  final UserService _userService;

  Future<void> markAsCompleted(Wish wish, {int quantity = 1}) async {
    final userId = _userService.getCurrentUserId();
    await _repository.markAsCompleted(
      userId: userId,
      wishId: wish.id,
      fromWishlistId: wish.wishlistId,
      quantity: quantity,
    );
  }

  Future<void> updateCompletedWishQuantity({
    required int wishId,
    required int newQuantity,
  }) async {
    final userId = _userService.getCurrentUserId();
    await _repository.updateCompletedWishQuantity(
      userId: userId,
      wishId: wishId,
      newQuantity: newQuantity,
    );
  }

  Future<void> unmarkAsCompleted(int wishId) async {
    final userId = _userService.getCurrentUserId();
    await _repository.unmarkAsCompleted(userId: userId, wishId: wishId);
  }
}

final completedWishServiceProvider = Provider<CompletedWishService>((ref) {
  return CompletedWishService(
    ref.watch(userCompletedWishRepositoryProvider),
    ref.watch(userServiceProvider),
  );
});
