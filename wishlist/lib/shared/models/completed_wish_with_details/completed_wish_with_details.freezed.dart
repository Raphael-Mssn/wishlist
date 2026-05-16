// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'completed_wish_with_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CompletedWishWithDetails _$CompletedWishWithDetailsFromJson(
    Map<String, dynamic> json) {
  return _CompletedWishWithDetails.fromJson(json);
}

/// @nodoc
mixin _$CompletedWishWithDetails {
  Wish get wish => throw _privateConstructorUsedError;
  @JsonKey(name: 'from_wishlist_id')
  int get fromWishlistId => throw _privateConstructorUsedError;
  @JsonKey(name: 'from_wishlist_name')
  String get fromWishlistName => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_pseudo')
  String get ownerPseudo => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id')
  String get ownerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_avatar_url')
  String? get ownerAvatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get completedAt => throw _privateConstructorUsedError;

  /// Serializes this CompletedWishWithDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompletedWishWithDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompletedWishWithDetailsCopyWith<CompletedWishWithDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompletedWishWithDetailsCopyWith<$Res> {
  factory $CompletedWishWithDetailsCopyWith(CompletedWishWithDetails value,
          $Res Function(CompletedWishWithDetails) then) =
      _$CompletedWishWithDetailsCopyWithImpl<$Res, CompletedWishWithDetails>;
  @useResult
  $Res call(
      {Wish wish,
      @JsonKey(name: 'from_wishlist_id') int fromWishlistId,
      @JsonKey(name: 'from_wishlist_name') String fromWishlistName,
      @JsonKey(name: 'owner_pseudo') String ownerPseudo,
      @JsonKey(name: 'owner_id') String ownerId,
      @JsonKey(name: 'owner_avatar_url') String? ownerAvatarUrl,
      @JsonKey(name: 'created_at') DateTime completedAt});
}

/// @nodoc
class _$CompletedWishWithDetailsCopyWithImpl<$Res,
        $Val extends CompletedWishWithDetails>
    implements $CompletedWishWithDetailsCopyWith<$Res> {
  _$CompletedWishWithDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompletedWishWithDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wish = null,
    Object? fromWishlistId = null,
    Object? fromWishlistName = null,
    Object? ownerPseudo = null,
    Object? ownerId = null,
    Object? ownerAvatarUrl = freezed,
    Object? completedAt = null,
  }) {
    return _then(_value.copyWith(
      wish: null == wish
          ? _value.wish
          : wish // ignore: cast_nullable_to_non_nullable
              as Wish,
      fromWishlistId: null == fromWishlistId
          ? _value.fromWishlistId
          : fromWishlistId // ignore: cast_nullable_to_non_nullable
              as int,
      fromWishlistName: null == fromWishlistName
          ? _value.fromWishlistName
          : fromWishlistName // ignore: cast_nullable_to_non_nullable
              as String,
      ownerPseudo: null == ownerPseudo
          ? _value.ownerPseudo
          : ownerPseudo // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      ownerAvatarUrl: freezed == ownerAvatarUrl
          ? _value.ownerAvatarUrl
          : ownerAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: null == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompletedWishWithDetailsImplCopyWith<$Res>
    implements $CompletedWishWithDetailsCopyWith<$Res> {
  factory _$$CompletedWishWithDetailsImplCopyWith(
          _$CompletedWishWithDetailsImpl value,
          $Res Function(_$CompletedWishWithDetailsImpl) then) =
      __$$CompletedWishWithDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Wish wish,
      @JsonKey(name: 'from_wishlist_id') int fromWishlistId,
      @JsonKey(name: 'from_wishlist_name') String fromWishlistName,
      @JsonKey(name: 'owner_pseudo') String ownerPseudo,
      @JsonKey(name: 'owner_id') String ownerId,
      @JsonKey(name: 'owner_avatar_url') String? ownerAvatarUrl,
      @JsonKey(name: 'created_at') DateTime completedAt});
}

/// @nodoc
class __$$CompletedWishWithDetailsImplCopyWithImpl<$Res>
    extends _$CompletedWishWithDetailsCopyWithImpl<$Res,
        _$CompletedWishWithDetailsImpl>
    implements _$$CompletedWishWithDetailsImplCopyWith<$Res> {
  __$$CompletedWishWithDetailsImplCopyWithImpl(
      _$CompletedWishWithDetailsImpl _value,
      $Res Function(_$CompletedWishWithDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of CompletedWishWithDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wish = null,
    Object? fromWishlistId = null,
    Object? fromWishlistName = null,
    Object? ownerPseudo = null,
    Object? ownerId = null,
    Object? ownerAvatarUrl = freezed,
    Object? completedAt = null,
  }) {
    return _then(_$CompletedWishWithDetailsImpl(
      wish: null == wish
          ? _value.wish
          : wish // ignore: cast_nullable_to_non_nullable
              as Wish,
      fromWishlistId: null == fromWishlistId
          ? _value.fromWishlistId
          : fromWishlistId // ignore: cast_nullable_to_non_nullable
              as int,
      fromWishlistName: null == fromWishlistName
          ? _value.fromWishlistName
          : fromWishlistName // ignore: cast_nullable_to_non_nullable
              as String,
      ownerPseudo: null == ownerPseudo
          ? _value.ownerPseudo
          : ownerPseudo // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      ownerAvatarUrl: freezed == ownerAvatarUrl
          ? _value.ownerAvatarUrl
          : ownerAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: null == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompletedWishWithDetailsImpl extends _CompletedWishWithDetails {
  const _$CompletedWishWithDetailsImpl(
      {required this.wish,
      @JsonKey(name: 'from_wishlist_id') required this.fromWishlistId,
      @JsonKey(name: 'from_wishlist_name') required this.fromWishlistName,
      @JsonKey(name: 'owner_pseudo') required this.ownerPseudo,
      @JsonKey(name: 'owner_id') required this.ownerId,
      @JsonKey(name: 'owner_avatar_url') this.ownerAvatarUrl,
      @JsonKey(name: 'created_at') required this.completedAt})
      : super._();

  factory _$CompletedWishWithDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompletedWishWithDetailsImplFromJson(json);

  @override
  final Wish wish;
  @override
  @JsonKey(name: 'from_wishlist_id')
  final int fromWishlistId;
  @override
  @JsonKey(name: 'from_wishlist_name')
  final String fromWishlistName;
  @override
  @JsonKey(name: 'owner_pseudo')
  final String ownerPseudo;
  @override
  @JsonKey(name: 'owner_id')
  final String ownerId;
  @override
  @JsonKey(name: 'owner_avatar_url')
  final String? ownerAvatarUrl;
  @override
  @JsonKey(name: 'created_at')
  final DateTime completedAt;

  @override
  String toString() {
    return 'CompletedWishWithDetails(wish: $wish, fromWishlistId: $fromWishlistId, fromWishlistName: $fromWishlistName, ownerPseudo: $ownerPseudo, ownerId: $ownerId, ownerAvatarUrl: $ownerAvatarUrl, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompletedWishWithDetailsImpl &&
            (identical(other.wish, wish) || other.wish == wish) &&
            (identical(other.fromWishlistId, fromWishlistId) ||
                other.fromWishlistId == fromWishlistId) &&
            (identical(other.fromWishlistName, fromWishlistName) ||
                other.fromWishlistName == fromWishlistName) &&
            (identical(other.ownerPseudo, ownerPseudo) ||
                other.ownerPseudo == ownerPseudo) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.ownerAvatarUrl, ownerAvatarUrl) ||
                other.ownerAvatarUrl == ownerAvatarUrl) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, wish, fromWishlistId,
      fromWishlistName, ownerPseudo, ownerId, ownerAvatarUrl, completedAt);

  /// Create a copy of CompletedWishWithDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompletedWishWithDetailsImplCopyWith<_$CompletedWishWithDetailsImpl>
      get copyWith => __$$CompletedWishWithDetailsImplCopyWithImpl<
          _$CompletedWishWithDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompletedWishWithDetailsImplToJson(
      this,
    );
  }
}

abstract class _CompletedWishWithDetails extends CompletedWishWithDetails {
  const factory _CompletedWishWithDetails(
          {required final Wish wish,
          @JsonKey(name: 'from_wishlist_id') required final int fromWishlistId,
          @JsonKey(name: 'from_wishlist_name')
          required final String fromWishlistName,
          @JsonKey(name: 'owner_pseudo') required final String ownerPseudo,
          @JsonKey(name: 'owner_id') required final String ownerId,
          @JsonKey(name: 'owner_avatar_url') final String? ownerAvatarUrl,
          @JsonKey(name: 'created_at') required final DateTime completedAt}) =
      _$CompletedWishWithDetailsImpl;
  const _CompletedWishWithDetails._() : super._();

  factory _CompletedWishWithDetails.fromJson(Map<String, dynamic> json) =
      _$CompletedWishWithDetailsImpl.fromJson;

  @override
  Wish get wish;
  @override
  @JsonKey(name: 'from_wishlist_id')
  int get fromWishlistId;
  @override
  @JsonKey(name: 'from_wishlist_name')
  String get fromWishlistName;
  @override
  @JsonKey(name: 'owner_pseudo')
  String get ownerPseudo;
  @override
  @JsonKey(name: 'owner_id')
  String get ownerId;
  @override
  @JsonKey(name: 'owner_avatar_url')
  String? get ownerAvatarUrl;
  @override
  @JsonKey(name: 'created_at')
  DateTime get completedAt;

  /// Create a copy of CompletedWishWithDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompletedWishWithDetailsImplCopyWith<_$CompletedWishWithDetailsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
