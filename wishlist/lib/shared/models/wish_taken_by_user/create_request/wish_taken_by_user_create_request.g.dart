// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wish_taken_by_user_create_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WishTakenByUserCreateRequestImpl _$$WishTakenByUserCreateRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$WishTakenByUserCreateRequestImpl(
      wishId: (json['wish_id'] as num).toInt(),
      userId: json['user_id'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$$WishTakenByUserCreateRequestImplToJson(
        _$WishTakenByUserCreateRequestImpl instance) =>
    <String, dynamic>{
      'wish_id': instance.wishId,
      'user_id': instance.userId,
      'quantity': instance.quantity,
    };
