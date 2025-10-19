// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booked_wish_with_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BookedWishWithDetails _$BookedWishWithDetailsFromJson(
    Map<String, dynamic> json) {
  return _BookedWishWithDetails.fromJson(json);
}

/// @nodoc
mixin _$BookedWishWithDetails {
  Wish get wish => throw _privateConstructorUsedError;
  @JsonKey(name: 'booked_quantity')
  int get bookedQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'wishlist_name')
  String get wishlistName => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_pseudo')
  String get ownerPseudo => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id')
  String get ownerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_avatar_url')
  String? get ownerAvatarUrl => throw _privateConstructorUsedError;

  /// Serializes this BookedWishWithDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookedWishWithDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookedWishWithDetailsCopyWith<BookedWishWithDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookedWishWithDetailsCopyWith<$Res> {
  factory $BookedWishWithDetailsCopyWith(BookedWishWithDetails value,
          $Res Function(BookedWishWithDetails) then) =
      _$BookedWishWithDetailsCopyWithImpl<$Res, BookedWishWithDetails>;
  @useResult
  $Res call(
      {Wish wish,
      @JsonKey(name: 'booked_quantity') int bookedQuantity,
      @JsonKey(name: 'wishlist_name') String wishlistName,
      @JsonKey(name: 'owner_pseudo') String ownerPseudo,
      @JsonKey(name: 'owner_id') String ownerId,
      @JsonKey(name: 'owner_avatar_url') String? ownerAvatarUrl});
}

/// @nodoc
class _$BookedWishWithDetailsCopyWithImpl<$Res,
        $Val extends BookedWishWithDetails>
    implements $BookedWishWithDetailsCopyWith<$Res> {
  _$BookedWishWithDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookedWishWithDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wish = null,
    Object? bookedQuantity = null,
    Object? wishlistName = null,
    Object? ownerPseudo = null,
    Object? ownerId = null,
    Object? ownerAvatarUrl = freezed,
  }) {
    return _then(_value.copyWith(
      wish: null == wish
          ? _value.wish
          : wish // ignore: cast_nullable_to_non_nullable
              as Wish,
      bookedQuantity: null == bookedQuantity
          ? _value.bookedQuantity
          : bookedQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      wishlistName: null == wishlistName
          ? _value.wishlistName
          : wishlistName // ignore: cast_nullable_to_non_nullable
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookedWishWithDetailsImplCopyWith<$Res>
    implements $BookedWishWithDetailsCopyWith<$Res> {
  factory _$$BookedWishWithDetailsImplCopyWith(
          _$BookedWishWithDetailsImpl value,
          $Res Function(_$BookedWishWithDetailsImpl) then) =
      __$$BookedWishWithDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Wish wish,
      @JsonKey(name: 'booked_quantity') int bookedQuantity,
      @JsonKey(name: 'wishlist_name') String wishlistName,
      @JsonKey(name: 'owner_pseudo') String ownerPseudo,
      @JsonKey(name: 'owner_id') String ownerId,
      @JsonKey(name: 'owner_avatar_url') String? ownerAvatarUrl});
}

/// @nodoc
class __$$BookedWishWithDetailsImplCopyWithImpl<$Res>
    extends _$BookedWishWithDetailsCopyWithImpl<$Res,
        _$BookedWishWithDetailsImpl>
    implements _$$BookedWishWithDetailsImplCopyWith<$Res> {
  __$$BookedWishWithDetailsImplCopyWithImpl(_$BookedWishWithDetailsImpl _value,
      $Res Function(_$BookedWishWithDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookedWishWithDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wish = null,
    Object? bookedQuantity = null,
    Object? wishlistName = null,
    Object? ownerPseudo = null,
    Object? ownerId = null,
    Object? ownerAvatarUrl = freezed,
  }) {
    return _then(_$BookedWishWithDetailsImpl(
      wish: null == wish
          ? _value.wish
          : wish // ignore: cast_nullable_to_non_nullable
              as Wish,
      bookedQuantity: null == bookedQuantity
          ? _value.bookedQuantity
          : bookedQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      wishlistName: null == wishlistName
          ? _value.wishlistName
          : wishlistName // ignore: cast_nullable_to_non_nullable
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookedWishWithDetailsImpl extends _BookedWishWithDetails {
  const _$BookedWishWithDetailsImpl(
      {required this.wish,
      @JsonKey(name: 'booked_quantity') required this.bookedQuantity,
      @JsonKey(name: 'wishlist_name') required this.wishlistName,
      @JsonKey(name: 'owner_pseudo') required this.ownerPseudo,
      @JsonKey(name: 'owner_id') required this.ownerId,
      @JsonKey(name: 'owner_avatar_url') this.ownerAvatarUrl})
      : super._();

  factory _$BookedWishWithDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookedWishWithDetailsImplFromJson(json);

  @override
  final Wish wish;
  @override
  @JsonKey(name: 'booked_quantity')
  final int bookedQuantity;
  @override
  @JsonKey(name: 'wishlist_name')
  final String wishlistName;
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
  String toString() {
    return 'BookedWishWithDetails(wish: $wish, bookedQuantity: $bookedQuantity, wishlistName: $wishlistName, ownerPseudo: $ownerPseudo, ownerId: $ownerId, ownerAvatarUrl: $ownerAvatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookedWishWithDetailsImpl &&
            (identical(other.wish, wish) || other.wish == wish) &&
            (identical(other.bookedQuantity, bookedQuantity) ||
                other.bookedQuantity == bookedQuantity) &&
            (identical(other.wishlistName, wishlistName) ||
                other.wishlistName == wishlistName) &&
            (identical(other.ownerPseudo, ownerPseudo) ||
                other.ownerPseudo == ownerPseudo) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.ownerAvatarUrl, ownerAvatarUrl) ||
                other.ownerAvatarUrl == ownerAvatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, wish, bookedQuantity,
      wishlistName, ownerPseudo, ownerId, ownerAvatarUrl);

  /// Create a copy of BookedWishWithDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookedWishWithDetailsImplCopyWith<_$BookedWishWithDetailsImpl>
      get copyWith => __$$BookedWishWithDetailsImplCopyWithImpl<
          _$BookedWishWithDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookedWishWithDetailsImplToJson(
      this,
    );
  }
}

abstract class _BookedWishWithDetails extends BookedWishWithDetails {
  const factory _BookedWishWithDetails(
          {required final Wish wish,
          @JsonKey(name: 'booked_quantity') required final int bookedQuantity,
          @JsonKey(name: 'wishlist_name') required final String wishlistName,
          @JsonKey(name: 'owner_pseudo') required final String ownerPseudo,
          @JsonKey(name: 'owner_id') required final String ownerId,
          @JsonKey(name: 'owner_avatar_url') final String? ownerAvatarUrl}) =
      _$BookedWishWithDetailsImpl;
  const _BookedWishWithDetails._() : super._();

  factory _BookedWishWithDetails.fromJson(Map<String, dynamic> json) =
      _$BookedWishWithDetailsImpl.fromJson;

  @override
  Wish get wish;
  @override
  @JsonKey(name: 'booked_quantity')
  int get bookedQuantity;
  @override
  @JsonKey(name: 'wishlist_name')
  String get wishlistName;
  @override
  @JsonKey(name: 'owner_pseudo')
  String get ownerPseudo;
  @override
  @JsonKey(name: 'owner_id')
  String get ownerId;
  @override
  @JsonKey(name: 'owner_avatar_url')
  String? get ownerAvatarUrl;

  /// Create a copy of BookedWishWithDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookedWishWithDetailsImplCopyWith<_$BookedWishWithDetailsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
