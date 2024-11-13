import 'package:freezed_annotation/freezed_annotation.dart';

part 'wish_taken_by_user_create_request.freezed.dart';
part 'wish_taken_by_user_create_request.g.dart';

@freezed
class WishTakenByUserCreateRequest with _$WishTakenByUserCreateRequest {
  const factory WishTakenByUserCreateRequest({
    @JsonKey(name: 'wish_id') required int wishId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'quantity') required int quantity,
  }) = _WishTakenByUserCreateRequest;

  const WishTakenByUserCreateRequest._();

  factory WishTakenByUserCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$WishTakenByUserCreateRequestFromJson(json);
}
