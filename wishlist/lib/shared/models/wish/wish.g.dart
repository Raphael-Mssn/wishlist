// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wish.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WishImpl _$$WishImplFromJson(Map<String, dynamic> json) => _$WishImpl(
      id: (json['id'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num?)?.toDouble(),
      linkUrl: json['link_url'] as String?,
      iconUrl: json['icon_url'] as String?,
      isFavourite: json['is_favourite'] as bool? ?? false,
      quantity: (json['quantity'] as num).toInt(),
      wishlistId: (json['wishlist_id'] as num).toInt(),
      updatedBy: json['updated_by'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$WishImplToJson(_$WishImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'link_url': instance.linkUrl,
      'icon_url': instance.iconUrl,
      'is_favourite': instance.isFavourite,
      'quantity': instance.quantity,
      'wishlist_id': instance.wishlistId,
      'updated_by': instance.updatedBy,
      'updated_at': instance.updatedAt.toIso8601String(),
    };
