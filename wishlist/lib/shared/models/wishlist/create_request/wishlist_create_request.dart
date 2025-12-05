import 'package:freezed_annotation/freezed_annotation.dart';

part 'wishlist_create_request.freezed.dart';
part 'wishlist_create_request.g.dart';

@freezed
class WishlistCreateRequest with _$WishlistCreateRequest {
  const factory WishlistCreateRequest({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'id_owner') required String idOwner,
    @JsonKey(name: 'color') required String color,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'is_closed') @Default(false) bool isClosed,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'can_owner_see_taken_wish')
    @Default(false)
    bool canOwnerSeeTakenWish,
    @JsonKey(name: 'visibility')
    @Default(WishlistVisibility.public)
    WishlistVisibility visibility,
    @JsonKey(name: 'order') required int order,
    @JsonKey(name: 'updated_by') required String updatedBy,
  }) = _WishlistCreateRequest;

  const WishlistCreateRequest._();

  factory WishlistCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$WishlistCreateRequestFromJson(json);
}

enum WishlistVisibility {
  private,
  public,
}
