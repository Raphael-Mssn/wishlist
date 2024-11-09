// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FriendDetailsImpl _$$FriendDetailsImplFromJson(Map<String, dynamic> json) =>
    _$FriendDetailsImpl(
      appUser: AppUser.fromJson(json['app_user'] as Map<String, dynamic>),
      mutualFriends: ISet<AppUser>.fromJson(json['mutual_friends'],
          (value) => AppUser.fromJson(value as Map<String, dynamic>)),
      publicWishlists: IList<Wishlist>.fromJson(json['public_wishlists'],
          (value) => Wishlist.fromJson(value as Map<String, dynamic>)),
      nbWishlists: (json['nb_wishlists'] as num).toInt(),
      nbWishs: (json['nb_wishs'] as num).toInt(),
    );

Map<String, dynamic> _$$FriendDetailsImplToJson(_$FriendDetailsImpl instance) =>
    <String, dynamic>{
      'app_user': instance.appUser,
      'mutual_friends': instance.mutualFriends.toJson(
        (value) => value,
      ),
      'public_wishlists': instance.publicWishlists.toJson(
        (value) => value,
      ),
      'nb_wishlists': instance.nbWishlists,
      'nb_wishs': instance.nbWishs,
    };
