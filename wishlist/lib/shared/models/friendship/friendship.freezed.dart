// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friendship.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Friendship _$FriendshipFromJson(Map<String, dynamic> json) {
  return _Friendship.fromJson(json);
}

/// @nodoc
mixin _$Friendship {
  @JsonKey(name: 'status')
  FriendshipStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'requester_id')
  String get requesterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'receiver_id')
  String get receiverId => throw _privateConstructorUsedError;

  /// Serializes this Friendship to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Friendship
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendshipCopyWith<Friendship> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendshipCopyWith<$Res> {
  factory $FriendshipCopyWith(
          Friendship value, $Res Function(Friendship) then) =
      _$FriendshipCopyWithImpl<$Res, Friendship>;
  @useResult
  $Res call(
      {@JsonKey(name: 'status') FriendshipStatus status,
      @JsonKey(name: 'requester_id') String requesterId,
      @JsonKey(name: 'receiver_id') String receiverId});
}

/// @nodoc
class _$FriendshipCopyWithImpl<$Res, $Val extends Friendship>
    implements $FriendshipCopyWith<$Res> {
  _$FriendshipCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Friendship
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? requesterId = null,
    Object? receiverId = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FriendshipStatus,
      requesterId: null == requesterId
          ? _value.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FriendshipImplCopyWith<$Res>
    implements $FriendshipCopyWith<$Res> {
  factory _$$FriendshipImplCopyWith(
          _$FriendshipImpl value, $Res Function(_$FriendshipImpl) then) =
      __$$FriendshipImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'status') FriendshipStatus status,
      @JsonKey(name: 'requester_id') String requesterId,
      @JsonKey(name: 'receiver_id') String receiverId});
}

/// @nodoc
class __$$FriendshipImplCopyWithImpl<$Res>
    extends _$FriendshipCopyWithImpl<$Res, _$FriendshipImpl>
    implements _$$FriendshipImplCopyWith<$Res> {
  __$$FriendshipImplCopyWithImpl(
      _$FriendshipImpl _value, $Res Function(_$FriendshipImpl) _then)
      : super(_value, _then);

  /// Create a copy of Friendship
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? requesterId = null,
    Object? receiverId = null,
  }) {
    return _then(_$FriendshipImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FriendshipStatus,
      requesterId: null == requesterId
          ? _value.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendshipImpl extends _Friendship {
  const _$FriendshipImpl(
      {@JsonKey(name: 'status') required this.status,
      @JsonKey(name: 'requester_id') required this.requesterId,
      @JsonKey(name: 'receiver_id') required this.receiverId})
      : super._();

  factory _$FriendshipImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendshipImplFromJson(json);

  @override
  @JsonKey(name: 'status')
  final FriendshipStatus status;
  @override
  @JsonKey(name: 'requester_id')
  final String requesterId;
  @override
  @JsonKey(name: 'receiver_id')
  final String receiverId;

  @override
  String toString() {
    return 'Friendship(status: $status, requesterId: $requesterId, receiverId: $receiverId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendshipImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.requesterId, requesterId) ||
                other.requesterId == requesterId) &&
            (identical(other.receiverId, receiverId) ||
                other.receiverId == receiverId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, requesterId, receiverId);

  /// Create a copy of Friendship
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendshipImplCopyWith<_$FriendshipImpl> get copyWith =>
      __$$FriendshipImplCopyWithImpl<_$FriendshipImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendshipImplToJson(
      this,
    );
  }
}

abstract class _Friendship extends Friendship {
  const factory _Friendship(
          {@JsonKey(name: 'status') required final FriendshipStatus status,
          @JsonKey(name: 'requester_id') required final String requesterId,
          @JsonKey(name: 'receiver_id') required final String receiverId}) =
      _$FriendshipImpl;
  const _Friendship._() : super._();

  factory _Friendship.fromJson(Map<String, dynamic> json) =
      _$FriendshipImpl.fromJson;

  @override
  @JsonKey(name: 'status')
  FriendshipStatus get status;
  @override
  @JsonKey(name: 'requester_id')
  String get requesterId;
  @override
  @JsonKey(name: 'receiver_id')
  String get receiverId;

  /// Create a copy of Friendship
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendshipImplCopyWith<_$FriendshipImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
