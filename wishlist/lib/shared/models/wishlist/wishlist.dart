import 'package:freezed_annotation/freezed_annotation.dart';

part 'wishlist.freezed.dart';
part 'wishlist.g.dart';

@freezed
class Wishlist with _$Wishlist {
  const factory Wishlist({
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
    @Default(WishlistVisibility.private)
    WishlistVisibility visibility,
    @JsonKey(name: 'updated_by') required String updatedBy,
  }) = _Wishlist;

  const Wishlist._();

  factory Wishlist.fromJson(Map<String, dynamic> json) =>
      _$WishlistFromJson(json);

  @JsonKey(includeToJson: false, includeFromJson: true)
  int get id => 0;

  @JsonKey(includeToJson: false, includeFromJson: true)
  DateTime get createdAt => DateTime.now();

  @JsonKey(includeToJson: false, includeFromJson: true)
  DateTime get updatedAt => DateTime.now();
}

enum WishlistVisibility {
  private,
  public,
}
