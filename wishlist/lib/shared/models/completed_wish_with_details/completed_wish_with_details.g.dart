// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed_wish_with_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompletedWishWithDetailsImpl _$$CompletedWishWithDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$CompletedWishWithDetailsImpl(
      wish: Wish.fromJson(json['wish'] as Map<String, dynamic>),
      fromWishlistId: (json['from_wishlist_id'] as num).toInt(),
      fromWishlistName: json['from_wishlist_name'] as String,
      ownerPseudo: json['owner_pseudo'] as String,
      ownerId: json['owner_id'] as String,
      ownerAvatarUrl: json['owner_avatar_url'] as String?,
    );

Map<String, dynamic> _$$CompletedWishWithDetailsImplToJson(
        _$CompletedWishWithDetailsImpl instance) =>
    <String, dynamic>{
      'wish': instance.wish,
      'from_wishlist_id': instance.fromWishlistId,
      'from_wishlist_name': instance.fromWishlistName,
      'owner_pseudo': instance.ownerPseudo,
      'owner_id': instance.ownerId,
      'owner_avatar_url': instance.ownerAvatarUrl,
    };
