import 'package:freezed_annotation/freezed_annotation.dart';

part 'wish_create_request.freezed.dart';
part 'wish_create_request.g.dart';

@freezed
class WishCreateRequest with _$WishCreateRequest {
  const factory WishCreateRequest({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') required String description,
    @JsonKey(name: 'price') double? price,
    @JsonKey(name: 'link_url') String? linkUrl,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'is_favourite') @Default(false) bool isFavourite,
    @JsonKey(name: 'quantity') int? quantity,
    @JsonKey(name: 'wishlist_id') required int wishlistId,
    @JsonKey(name: 'updated_by') required String updatedBy,
  }) = _WishCreateRequest;

  const WishCreateRequest._();

  factory WishCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$WishCreateRequestFromJson(json);
}
