import 'package:freezed_annotation/freezed_annotation.dart';

part 'wish_update_request.freezed.dart';
part 'wish_update_request.g.dart';

@freezed
class WishUpdateRequest with _$WishUpdateRequest {
  const factory WishUpdateRequest({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') required String description,
    @JsonKey(name: 'price') double? price,
    @JsonKey(name: 'link_url') String? linkUrl,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'is_favourite') @Default(false) bool isFavourite,
    @JsonKey(name: 'quantity') int? quantity,
    @JsonKey(name: 'wishlist_id') required int wishlistId,
    @JsonKey(name: 'updated_by') required String updatedBy,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _WishUpdateRequest;

  const WishUpdateRequest._();

  factory WishUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$WishUpdateRequestFromJson(json);
}
