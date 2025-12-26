// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wish_taken_by_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WishTakenByUser _$WishTakenByUserFromJson(Map<String, dynamic> json) {
  return _WishTakenByUser.fromJson(json);
}

/// @nodoc
mixin _$WishTakenByUser {
  @JsonKey(name: 'wish_id')
  int get wishId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'quantity')
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // Données du profil (chargées via un join)
  @JsonKey(name: 'user_pseudo', includeToJson: false)
  String? get userPseudo => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_avatar_url', includeToJson: false)
  String? get userAvatarUrl => throw _privateConstructorUsedError;

  /// Serializes this WishTakenByUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WishTakenByUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WishTakenByUserCopyWith<WishTakenByUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WishTakenByUserCopyWith<$Res> {
  factory $WishTakenByUserCopyWith(
          WishTakenByUser value, $Res Function(WishTakenByUser) then) =
      _$WishTakenByUserCopyWithImpl<$Res, WishTakenByUser>;
  @useResult
  $Res call(
      {@JsonKey(name: 'wish_id') int wishId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'quantity') int quantity,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'user_pseudo', includeToJson: false) String? userPseudo,
      @JsonKey(name: 'user_avatar_url', includeToJson: false)
      String? userAvatarUrl});
}

/// @nodoc
class _$WishTakenByUserCopyWithImpl<$Res, $Val extends WishTakenByUser>
    implements $WishTakenByUserCopyWith<$Res> {
  _$WishTakenByUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WishTakenByUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wishId = null,
    Object? userId = null,
    Object? quantity = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userPseudo = freezed,
    Object? userAvatarUrl = freezed,
  }) {
    return _then(_value.copyWith(
      wishId: null == wishId
          ? _value.wishId
          : wishId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userPseudo: freezed == userPseudo
          ? _value.userPseudo
          : userPseudo // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatarUrl: freezed == userAvatarUrl
          ? _value.userAvatarUrl
          : userAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WishTakenByUserImplCopyWith<$Res>
    implements $WishTakenByUserCopyWith<$Res> {
  factory _$$WishTakenByUserImplCopyWith(_$WishTakenByUserImpl value,
          $Res Function(_$WishTakenByUserImpl) then) =
      __$$WishTakenByUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'wish_id') int wishId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'quantity') int quantity,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'user_pseudo', includeToJson: false) String? userPseudo,
      @JsonKey(name: 'user_avatar_url', includeToJson: false)
      String? userAvatarUrl});
}

/// @nodoc
class __$$WishTakenByUserImplCopyWithImpl<$Res>
    extends _$WishTakenByUserCopyWithImpl<$Res, _$WishTakenByUserImpl>
    implements _$$WishTakenByUserImplCopyWith<$Res> {
  __$$WishTakenByUserImplCopyWithImpl(
      _$WishTakenByUserImpl _value, $Res Function(_$WishTakenByUserImpl) _then)
      : super(_value, _then);

  /// Create a copy of WishTakenByUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wishId = null,
    Object? userId = null,
    Object? quantity = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userPseudo = freezed,
    Object? userAvatarUrl = freezed,
  }) {
    return _then(_$WishTakenByUserImpl(
      wishId: null == wishId
          ? _value.wishId
          : wishId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userPseudo: freezed == userPseudo
          ? _value.userPseudo
          : userPseudo // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatarUrl: freezed == userAvatarUrl
          ? _value.userAvatarUrl
          : userAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WishTakenByUserImpl extends _WishTakenByUser {
  const _$WishTakenByUserImpl(
      {@JsonKey(name: 'wish_id') required this.wishId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'quantity') required this.quantity,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'user_pseudo', includeToJson: false) this.userPseudo,
      @JsonKey(name: 'user_avatar_url', includeToJson: false)
      this.userAvatarUrl})
      : super._();

  factory _$WishTakenByUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$WishTakenByUserImplFromJson(json);

  @override
  @JsonKey(name: 'wish_id')
  final int wishId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'quantity')
  final int quantity;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
// Données du profil (chargées via un join)
  @override
  @JsonKey(name: 'user_pseudo', includeToJson: false)
  final String? userPseudo;
  @override
  @JsonKey(name: 'user_avatar_url', includeToJson: false)
  final String? userAvatarUrl;

  @override
  String toString() {
    return 'WishTakenByUser(wishId: $wishId, userId: $userId, quantity: $quantity, createdAt: $createdAt, updatedAt: $updatedAt, userPseudo: $userPseudo, userAvatarUrl: $userAvatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WishTakenByUserImpl &&
            (identical(other.wishId, wishId) || other.wishId == wishId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.userPseudo, userPseudo) ||
                other.userPseudo == userPseudo) &&
            (identical(other.userAvatarUrl, userAvatarUrl) ||
                other.userAvatarUrl == userAvatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, wishId, userId, quantity,
      createdAt, updatedAt, userPseudo, userAvatarUrl);

  /// Create a copy of WishTakenByUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WishTakenByUserImplCopyWith<_$WishTakenByUserImpl> get copyWith =>
      __$$WishTakenByUserImplCopyWithImpl<_$WishTakenByUserImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WishTakenByUserImplToJson(
      this,
    );
  }
}

abstract class _WishTakenByUser extends WishTakenByUser {
  const factory _WishTakenByUser(
      {@JsonKey(name: 'wish_id') required final int wishId,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'quantity') required final int quantity,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      @JsonKey(name: 'user_pseudo', includeToJson: false)
      final String? userPseudo,
      @JsonKey(name: 'user_avatar_url', includeToJson: false)
      final String? userAvatarUrl}) = _$WishTakenByUserImpl;
  const _WishTakenByUser._() : super._();

  factory _WishTakenByUser.fromJson(Map<String, dynamic> json) =
      _$WishTakenByUserImpl.fromJson;

  @override
  @JsonKey(name: 'wish_id')
  int get wishId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'quantity')
  int get quantity;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt; // Données du profil (chargées via un join)
  @override
  @JsonKey(name: 'user_pseudo', includeToJson: false)
  String? get userPseudo;
  @override
  @JsonKey(name: 'user_avatar_url', includeToJson: false)
  String? get userAvatarUrl;

  /// Create a copy of WishTakenByUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WishTakenByUserImplCopyWith<_$WishTakenByUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
