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
      wishlists: IList<Wishlist>.fromJson(json['wishlists'],
          (value) => Wishlist.fromJson(value as Map<String, dynamic>)),
      nbOfWishs: (json['nb_of_wishs'] as num).toInt(),
    );

Map<String, dynamic> _$$FriendDetailsImplToJson(_$FriendDetailsImpl instance) =>
    <String, dynamic>{
      'app_user': instance.appUser,
      'mutual_friends': instance.mutualFriends.toJson(
        (value) => value,
      ),
      'wishlists': instance.wishlists.toJson(
        (value) => value,
      ),
      'nb_of_wishs': instance.nbOfWishs,
    };
