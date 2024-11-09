import 'package:freezed_annotation/freezed_annotation.dart';

part 'wish.freezed.dart';
part 'wish.g.dart';

@freezed
class Wish with _$Wish {
  const factory Wish({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') required String description,
    @JsonKey(name: 'price') double? price,
    @JsonKey(name: 'link_url') String? linkUrl,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'is_favourite') @Default(false) bool isFavourite,
    @JsonKey(name: 'quantity') required int quantity,
    @JsonKey(name: 'wishlist_id') required int wishlistId,
    @JsonKey(name: 'updated_by') required String updatedBy,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Wish;

  const Wish._();

  factory Wish.fromJson(Map<String, dynamic> json) => _$WishFromJson(json);
}
