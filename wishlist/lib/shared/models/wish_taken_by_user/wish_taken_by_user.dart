import 'package:freezed_annotation/freezed_annotation.dart';

part 'wish_taken_by_user.freezed.dart';
part 'wish_taken_by_user.g.dart';

@freezed
class WishTakenByUser with _$WishTakenByUser {
  const factory WishTakenByUser({
    @JsonKey(name: 'wish_id') required int wishId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'quantity') required int quantity,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Données du profil (chargées via un join)
    @JsonKey(name: 'user_pseudo', includeToJson: false) String? userPseudo,
    @JsonKey(name: 'user_avatar_url', includeToJson: false)
    String? userAvatarUrl,
  }) = _WishTakenByUser;

  const WishTakenByUser._();

  factory WishTakenByUser.fromJson(Map<String, dynamic> json) =>
      _$WishTakenByUserFromJson(json);
}
