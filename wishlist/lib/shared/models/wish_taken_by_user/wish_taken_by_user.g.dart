// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wish_taken_by_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WishTakenByUserImpl _$$WishTakenByUserImplFromJson(
        Map<String, dynamic> json) =>
    _$WishTakenByUserImpl(
      wishId: (json['wish_id'] as num).toInt(),
      userId: json['user_id'] as String,
      quantity: (json['quantity'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$WishTakenByUserImplToJson(
        _$WishTakenByUserImpl instance) =>
    <String, dynamic>{
      'wish_id': instance.wishId,
      'user_id': instance.userId,
      'quantity': instance.quantity,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
