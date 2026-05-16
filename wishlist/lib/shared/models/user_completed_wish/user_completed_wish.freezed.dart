// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_completed_wish.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserCompletedWish _$UserCompletedWishFromJson(Map<String, dynamic> json) {
  return _UserCompletedWish.fromJson(json);
}

/// @nodoc
mixin _$UserCompletedWish {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'wish_id')
  int get wishId => throw _privateConstructorUsedError;
  @JsonKey(name: 'from_wishlist_id')
  int get fromWishlistId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this UserCompletedWish to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserCompletedWish
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCompletedWishCopyWith<UserCompletedWish> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCompletedWishCopyWith<$Res> {
  factory $UserCompletedWishCopyWith(
          UserCompletedWish value, $Res Function(UserCompletedWish) then) =
      _$UserCompletedWishCopyWithImpl<$Res, UserCompletedWish>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'wish_id') int wishId,
      @JsonKey(name: 'from_wishlist_id') int fromWishlistId,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$UserCompletedWishCopyWithImpl<$Res, $Val extends UserCompletedWish>
    implements $UserCompletedWishCopyWith<$Res> {
  _$UserCompletedWishCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserCompletedWish
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? wishId = null,
    Object? fromWishlistId = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      wishId: null == wishId
          ? _value.wishId
          : wishId // ignore: cast_nullable_to_non_nullable
              as int,
      fromWishlistId: null == fromWishlistId
          ? _value.fromWishlistId
          : fromWishlistId // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserCompletedWishImplCopyWith<$Res>
    implements $UserCompletedWishCopyWith<$Res> {
  factory _$$UserCompletedWishImplCopyWith(_$UserCompletedWishImpl value,
          $Res Function(_$UserCompletedWishImpl) then) =
      __$$UserCompletedWishImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'wish_id') int wishId,
      @JsonKey(name: 'from_wishlist_id') int fromWishlistId,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$UserCompletedWishImplCopyWithImpl<$Res>
    extends _$UserCompletedWishCopyWithImpl<$Res, _$UserCompletedWishImpl>
    implements _$$UserCompletedWishImplCopyWith<$Res> {
  __$$UserCompletedWishImplCopyWithImpl(_$UserCompletedWishImpl _value,
      $Res Function(_$UserCompletedWishImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserCompletedWish
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? wishId = null,
    Object? fromWishlistId = null,
    Object? createdAt = null,
  }) {
    return _then(_$UserCompletedWishImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      wishId: null == wishId
          ? _value.wishId
          : wishId // ignore: cast_nullable_to_non_nullable
              as int,
      fromWishlistId: null == fromWishlistId
          ? _value.fromWishlistId
          : fromWishlistId // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserCompletedWishImpl extends _UserCompletedWish {
  const _$UserCompletedWishImpl(
      {@JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'wish_id') required this.wishId,
      @JsonKey(name: 'from_wishlist_id') required this.fromWishlistId,
      @JsonKey(name: 'created_at') required this.createdAt})
      : super._();

  factory _$UserCompletedWishImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserCompletedWishImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'wish_id')
  final int wishId;
  @override
  @JsonKey(name: 'from_wishlist_id')
  final int fromWishlistId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'UserCompletedWish(userId: $userId, wishId: $wishId, fromWishlistId: $fromWishlistId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserCompletedWishImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.wishId, wishId) || other.wishId == wishId) &&
            (identical(other.fromWishlistId, fromWishlistId) ||
                other.fromWishlistId == fromWishlistId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, wishId, fromWishlistId, createdAt);

  /// Create a copy of UserCompletedWish
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserCompletedWishImplCopyWith<_$UserCompletedWishImpl> get copyWith =>
      __$$UserCompletedWishImplCopyWithImpl<_$UserCompletedWishImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserCompletedWishImplToJson(
      this,
    );
  }
}

abstract class _UserCompletedWish extends UserCompletedWish {
  const factory _UserCompletedWish(
          {@JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'wish_id') required final int wishId,
          @JsonKey(name: 'from_wishlist_id') required final int fromWishlistId,
          @JsonKey(name: 'created_at') required final DateTime createdAt}) =
      _$UserCompletedWishImpl;
  const _UserCompletedWish._() : super._();

  factory _UserCompletedWish.fromJson(Map<String, dynamic> json) =
      _$UserCompletedWishImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'wish_id')
  int get wishId;
  @override
  @JsonKey(name: 'from_wishlist_id')
  int get fromWishlistId;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of UserCompletedWish
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserCompletedWishImplCopyWith<_$UserCompletedWishImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
