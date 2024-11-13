// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wish_taken_by_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WishTakenByUserImpl _$$WishTakenByUserImplFromJson(
        Map<String, dynamic> json) =>
    _$WishTakenByUserImpl(
      wishId: (json['wish_id'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$$WishTakenByUserImplToJson(
        _$WishTakenByUserImpl instance) =>
    <String, dynamic>{
      'wish_id': instance.wishId,
      'quantity': instance.quantity,
      'user_id': instance.userId,
    };
