// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_completed_wish.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserCompletedWishImpl _$$UserCompletedWishImplFromJson(
        Map<String, dynamic> json) =>
    _$UserCompletedWishImpl(
      userId: json['user_id'] as String,
      wishId: (json['wish_id'] as num).toInt(),
      fromWishlistId: (json['from_wishlist_id'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      quantity: (json['quantity'] as num).toInt(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$UserCompletedWishImplToJson(
        _$UserCompletedWishImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'wish_id': instance.wishId,
      'from_wishlist_id': instance.fromWishlistId,
      'created_at': instance.createdAt.toIso8601String(),
      'quantity': instance.quantity,
      'updated_at': instance.updatedAt.toIso8601String(),
    };
