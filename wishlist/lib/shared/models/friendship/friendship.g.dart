// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FriendshipImpl _$$FriendshipImplFromJson(Map<String, dynamic> json) =>
    _$FriendshipImpl(
      status: $enumDecode(_$FriendshipStatusEnumMap, json['status']),
      requesterId: json['requester_id'] as String,
      receiverId: json['receiver_id'] as String,
    );

Map<String, dynamic> _$$FriendshipImplToJson(_$FriendshipImpl instance) =>
    <String, dynamic>{
      'status': _$FriendshipStatusEnumMap[instance.status]!,
      'requester_id': instance.requesterId,
      'receiver_id': instance.receiverId,
    };

const _$FriendshipStatusEnumMap = {
  FriendshipStatus.none: 'none',
  FriendshipStatus.accepted: 'accepted',
  FriendshipStatus.pending: 'pending',
  FriendshipStatus.rejected: 'rejected',
  FriendshipStatus.blocked: 'blocked',
};
