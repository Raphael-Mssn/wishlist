import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wishlist/shared/infra/utils/update_entity.dart';

part 'wishlist.freezed.dart';
part 'wishlist.g.dart';

@Freezed(copyWith: false)
class Wishlist with _$Wishlist implements Updatable {
  const factory Wishlist({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'created_at') required DateTime createdAt,
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
    @JsonKey(name: 'order') required int order,
    @JsonKey(name: 'updated_by') required String updatedBy,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Wishlist;

  const Wishlist._();

  factory Wishlist.fromJson(Map<String, dynamic> json) =>
      _$WishlistFromJson(json);

  @override
  Wishlist copyWith({
    String? name,
    String? color,
    String? iconUrl,
    bool? isClosed,
    DateTime? endDate,
    bool? canOwnerSeeTakenWish,
    WishlistVisibility? visibility,
    int? order,
    String? updatedBy,
    DateTime? updatedAt,
  }) {
    return Wishlist(
      id: id,
      createdAt: createdAt,
      name: name ?? this.name,
      idOwner: idOwner,
      color: color ?? this.color,
      iconUrl: iconUrl ?? this.iconUrl,
      isClosed: isClosed ?? this.isClosed,
      endDate: endDate ?? this.endDate,
      canOwnerSeeTakenWish: canOwnerSeeTakenWish ?? this.canOwnerSeeTakenWish,
      visibility: visibility ?? this.visibility,
      order: order ?? this.order,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum WishlistVisibility {
  private,
  public,
}
