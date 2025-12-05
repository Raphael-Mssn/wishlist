// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_create_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WishlistCreateRequestImpl _$$WishlistCreateRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$WishlistCreateRequestImpl(
      name: json['name'] as String,
      idOwner: json['id_owner'] as String,
      color: json['color'] as String,
      iconUrl: json['icon_url'] as String?,
      isClosed: json['is_closed'] as bool? ?? false,
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      canOwnerSeeTakenWish: json['can_owner_see_taken_wish'] as bool? ?? false,
      visibility: $enumDecodeNullable(
              _$WishlistVisibilityEnumMap, json['visibility']) ??
          WishlistVisibility.public,
      order: (json['order'] as num).toInt(),
      updatedBy: json['updated_by'] as String,
    );

Map<String, dynamic> _$$WishlistCreateRequestImplToJson(
        _$WishlistCreateRequestImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id_owner': instance.idOwner,
      'color': instance.color,
      'icon_url': instance.iconUrl,
      'is_closed': instance.isClosed,
      'end_date': instance.endDate?.toIso8601String(),
      'can_owner_see_taken_wish': instance.canOwnerSeeTakenWish,
      'visibility': _$WishlistVisibilityEnumMap[instance.visibility]!,
      'order': instance.order,
      'updated_by': instance.updatedBy,
    };

const _$WishlistVisibilityEnumMap = {
  WishlistVisibility.private: 'private',
  WishlistVisibility.public: 'public',
};
