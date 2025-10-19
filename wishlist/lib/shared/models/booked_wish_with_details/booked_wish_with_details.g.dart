// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booked_wish_with_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookedWishWithDetailsImpl _$$BookedWishWithDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$BookedWishWithDetailsImpl(
      wish: Wish.fromJson(json['wish'] as Map<String, dynamic>),
      bookedQuantity: (json['booked_quantity'] as num).toInt(),
      wishlistName: json['wishlist_name'] as String,
      ownerPseudo: json['owner_pseudo'] as String,
      ownerId: json['owner_id'] as String,
      ownerAvatarUrl: json['owner_avatar_url'] as String?,
    );

Map<String, dynamic> _$$BookedWishWithDetailsImplToJson(
        _$BookedWishWithDetailsImpl instance) =>
    <String, dynamic>{
      'wish': instance.wish,
      'booked_quantity': instance.bookedQuantity,
      'wishlist_name': instance.wishlistName,
      'owner_pseudo': instance.ownerPseudo,
      'owner_id': instance.ownerId,
      'owner_avatar_url': instance.ownerAvatarUrl,
    };
