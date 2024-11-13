// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wish_taken_by_user_create_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WishTakenByUserCreateRequest _$WishTakenByUserCreateRequestFromJson(
    Map<String, dynamic> json) {
  return _WishTakenByUserCreateRequest.fromJson(json);
}

/// @nodoc
mixin _$WishTakenByUserCreateRequest {
  @JsonKey(name: 'wish_id')
  int get wishId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'quantity')
  int get quantity => throw _privateConstructorUsedError;

  /// Serializes this WishTakenByUserCreateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WishTakenByUserCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WishTakenByUserCreateRequestCopyWith<WishTakenByUserCreateRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WishTakenByUserCreateRequestCopyWith<$Res> {
  factory $WishTakenByUserCreateRequestCopyWith(
          WishTakenByUserCreateRequest value,
          $Res Function(WishTakenByUserCreateRequest) then) =
      _$WishTakenByUserCreateRequestCopyWithImpl<$Res,
          WishTakenByUserCreateRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'wish_id') int wishId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'quantity') int quantity});
}

/// @nodoc
class _$WishTakenByUserCreateRequestCopyWithImpl<$Res,
        $Val extends WishTakenByUserCreateRequest>
    implements $WishTakenByUserCreateRequestCopyWith<$Res> {
  _$WishTakenByUserCreateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WishTakenByUserCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wishId = null,
    Object? userId = null,
    Object? quantity = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WishTakenByUserCreateRequestImplCopyWith<$Res>
    implements $WishTakenByUserCreateRequestCopyWith<$Res> {
  factory _$$WishTakenByUserCreateRequestImplCopyWith(
          _$WishTakenByUserCreateRequestImpl value,
          $Res Function(_$WishTakenByUserCreateRequestImpl) then) =
      __$$WishTakenByUserCreateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'wish_id') int wishId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'quantity') int quantity});
}

/// @nodoc
class __$$WishTakenByUserCreateRequestImplCopyWithImpl<$Res>
    extends _$WishTakenByUserCreateRequestCopyWithImpl<$Res,
        _$WishTakenByUserCreateRequestImpl>
    implements _$$WishTakenByUserCreateRequestImplCopyWith<$Res> {
  __$$WishTakenByUserCreateRequestImplCopyWithImpl(
      _$WishTakenByUserCreateRequestImpl _value,
      $Res Function(_$WishTakenByUserCreateRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of WishTakenByUserCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wishId = null,
    Object? userId = null,
    Object? quantity = null,
  }) {
    return _then(_$WishTakenByUserCreateRequestImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WishTakenByUserCreateRequestImpl extends _WishTakenByUserCreateRequest {
  const _$WishTakenByUserCreateRequestImpl(
      {@JsonKey(name: 'wish_id') required this.wishId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'quantity') required this.quantity})
      : super._();

  factory _$WishTakenByUserCreateRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$WishTakenByUserCreateRequestImplFromJson(json);

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
  String toString() {
    return 'WishTakenByUserCreateRequest(wishId: $wishId, userId: $userId, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WishTakenByUserCreateRequestImpl &&
            (identical(other.wishId, wishId) || other.wishId == wishId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, wishId, userId, quantity);

  /// Create a copy of WishTakenByUserCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WishTakenByUserCreateRequestImplCopyWith<
          _$WishTakenByUserCreateRequestImpl>
      get copyWith => __$$WishTakenByUserCreateRequestImplCopyWithImpl<
          _$WishTakenByUserCreateRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WishTakenByUserCreateRequestImplToJson(
      this,
    );
  }
}

abstract class _WishTakenByUserCreateRequest
    extends WishTakenByUserCreateRequest {
  const factory _WishTakenByUserCreateRequest(
          {@JsonKey(name: 'wish_id') required final int wishId,
          @JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'quantity') required final int quantity}) =
      _$WishTakenByUserCreateRequestImpl;
  const _WishTakenByUserCreateRequest._() : super._();

  factory _WishTakenByUserCreateRequest.fromJson(Map<String, dynamic> json) =
      _$WishTakenByUserCreateRequestImpl.fromJson;

  @override
  @JsonKey(name: 'wish_id')
  int get wishId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'quantity')
  int get quantity;

  /// Create a copy of WishTakenByUserCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WishTakenByUserCreateRequestImplCopyWith<
          _$WishTakenByUserCreateRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
