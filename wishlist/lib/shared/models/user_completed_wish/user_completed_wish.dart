import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_completed_wish.freezed.dart';
part 'user_completed_wish.g.dart';

@freezed
class UserCompletedWish with _$UserCompletedWish {
  const factory UserCompletedWish({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'wish_id') required int wishId,
    @JsonKey(name: 'from_wishlist_id') required int fromWishlistId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'quantity') required int quantity,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _UserCompletedWish;

  const UserCompletedWish._();

  factory UserCompletedWish.fromJson(Map<String, dynamic> json) =>
      _$UserCompletedWishFromJson(json);
}
