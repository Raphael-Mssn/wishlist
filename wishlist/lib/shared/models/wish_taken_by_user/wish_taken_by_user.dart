import 'package:freezed_annotation/freezed_annotation.dart';

part 'wish_taken_by_user.freezed.dart';
part 'wish_taken_by_user.g.dart';

@freezed
class WishTakenByUser with _$WishTakenByUser {
  const factory WishTakenByUser({
    @JsonKey(name: 'wish_id') required int wishId,
    @JsonKey(name: 'quantity') required int quantity,
    @JsonKey(name: 'user_id') required String userId,
  }) = _WishTakenByUser;

  const WishTakenByUser._();

  factory WishTakenByUser.fromJson(Map<String, dynamic> json) =>
      _$WishTakenByUserFromJson(json);

  @JsonKey(includeToJson: false, includeFromJson: true)
  DateTime get updatedAt => DateTime.now();
}
