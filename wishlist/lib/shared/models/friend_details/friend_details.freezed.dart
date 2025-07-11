// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FriendDetails _$FriendDetailsFromJson(Map<String, dynamic> json) {
  return _FriendDetails.fromJson(json);
}

/// @nodoc
mixin _$FriendDetails {
  @JsonKey(name: 'app_user')
  AppUser get appUser => throw _privateConstructorUsedError;
  @JsonKey(name: 'mutual_friends')
  ISet<AppUser> get mutualFriends => throw _privateConstructorUsedError;
  @JsonKey(name: 'public_wishlists')
  IList<Wishlist> get publicWishlists => throw _privateConstructorUsedError;
  @JsonKey(name: 'nb_wishlists')
  int get nbWishlists => throw _privateConstructorUsedError;
  @JsonKey(name: 'nb_wishs')
  int get nbWishs => throw _privateConstructorUsedError;

  /// Serializes this FriendDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FriendDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendDetailsCopyWith<FriendDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendDetailsCopyWith<$Res> {
  factory $FriendDetailsCopyWith(
          FriendDetails value, $Res Function(FriendDetails) then) =
      _$FriendDetailsCopyWithImpl<$Res, FriendDetails>;
  @useResult
  $Res call(
      {@JsonKey(name: 'app_user') AppUser appUser,
      @JsonKey(name: 'mutual_friends') ISet<AppUser> mutualFriends,
      @JsonKey(name: 'public_wishlists') IList<Wishlist> publicWishlists,
      @JsonKey(name: 'nb_wishlists') int nbWishlists,
      @JsonKey(name: 'nb_wishs') int nbWishs});
}

/// @nodoc
class _$FriendDetailsCopyWithImpl<$Res, $Val extends FriendDetails>
    implements $FriendDetailsCopyWith<$Res> {
  _$FriendDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appUser = null,
    Object? mutualFriends = null,
    Object? publicWishlists = null,
    Object? nbWishlists = null,
    Object? nbWishs = null,
  }) {
    return _then(_value.copyWith(
      appUser: null == appUser
          ? _value.appUser
          : appUser // ignore: cast_nullable_to_non_nullable
              as AppUser,
      mutualFriends: null == mutualFriends
          ? _value.mutualFriends
          : mutualFriends // ignore: cast_nullable_to_non_nullable
              as ISet<AppUser>,
      publicWishlists: null == publicWishlists
          ? _value.publicWishlists
          : publicWishlists // ignore: cast_nullable_to_non_nullable
              as IList<Wishlist>,
      nbWishlists: null == nbWishlists
          ? _value.nbWishlists
          : nbWishlists // ignore: cast_nullable_to_non_nullable
              as int,
      nbWishs: null == nbWishs
          ? _value.nbWishs
          : nbWishs // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FriendDetailsImplCopyWith<$Res>
    implements $FriendDetailsCopyWith<$Res> {
  factory _$$FriendDetailsImplCopyWith(
          _$FriendDetailsImpl value, $Res Function(_$FriendDetailsImpl) then) =
      __$$FriendDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'app_user') AppUser appUser,
      @JsonKey(name: 'mutual_friends') ISet<AppUser> mutualFriends,
      @JsonKey(name: 'public_wishlists') IList<Wishlist> publicWishlists,
      @JsonKey(name: 'nb_wishlists') int nbWishlists,
      @JsonKey(name: 'nb_wishs') int nbWishs});
}

/// @nodoc
class __$$FriendDetailsImplCopyWithImpl<$Res>
    extends _$FriendDetailsCopyWithImpl<$Res, _$FriendDetailsImpl>
    implements _$$FriendDetailsImplCopyWith<$Res> {
  __$$FriendDetailsImplCopyWithImpl(
      _$FriendDetailsImpl _value, $Res Function(_$FriendDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of FriendDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appUser = null,
    Object? mutualFriends = null,
    Object? publicWishlists = null,
    Object? nbWishlists = null,
    Object? nbWishs = null,
  }) {
    return _then(_$FriendDetailsImpl(
      appUser: null == appUser
          ? _value.appUser
          : appUser // ignore: cast_nullable_to_non_nullable
              as AppUser,
      mutualFriends: null == mutualFriends
          ? _value.mutualFriends
          : mutualFriends // ignore: cast_nullable_to_non_nullable
              as ISet<AppUser>,
      publicWishlists: null == publicWishlists
          ? _value.publicWishlists
          : publicWishlists // ignore: cast_nullable_to_non_nullable
              as IList<Wishlist>,
      nbWishlists: null == nbWishlists
          ? _value.nbWishlists
          : nbWishlists // ignore: cast_nullable_to_non_nullable
              as int,
      nbWishs: null == nbWishs
          ? _value.nbWishs
          : nbWishs // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendDetailsImpl extends _FriendDetails {
  const _$FriendDetailsImpl(
      {@JsonKey(name: 'app_user') required this.appUser,
      @JsonKey(name: 'mutual_friends') required this.mutualFriends,
      @JsonKey(name: 'public_wishlists') required this.publicWishlists,
      @JsonKey(name: 'nb_wishlists') required this.nbWishlists,
      @JsonKey(name: 'nb_wishs') required this.nbWishs})
      : super._();

  factory _$FriendDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendDetailsImplFromJson(json);

  @override
  @JsonKey(name: 'app_user')
  final AppUser appUser;
  @override
  @JsonKey(name: 'mutual_friends')
  final ISet<AppUser> mutualFriends;
  @override
  @JsonKey(name: 'public_wishlists')
  final IList<Wishlist> publicWishlists;
  @override
  @JsonKey(name: 'nb_wishlists')
  final int nbWishlists;
  @override
  @JsonKey(name: 'nb_wishs')
  final int nbWishs;

  @override
  String toString() {
    return 'FriendDetails(appUser: $appUser, mutualFriends: $mutualFriends, publicWishlists: $publicWishlists, nbWishlists: $nbWishlists, nbWishs: $nbWishs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendDetailsImpl &&
            (identical(other.appUser, appUser) || other.appUser == appUser) &&
            const DeepCollectionEquality()
                .equals(other.mutualFriends, mutualFriends) &&
            const DeepCollectionEquality()
                .equals(other.publicWishlists, publicWishlists) &&
            (identical(other.nbWishlists, nbWishlists) ||
                other.nbWishlists == nbWishlists) &&
            (identical(other.nbWishs, nbWishs) || other.nbWishs == nbWishs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      appUser,
      const DeepCollectionEquality().hash(mutualFriends),
      const DeepCollectionEquality().hash(publicWishlists),
      nbWishlists,
      nbWishs);

  /// Create a copy of FriendDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendDetailsImplCopyWith<_$FriendDetailsImpl> get copyWith =>
      __$$FriendDetailsImplCopyWithImpl<_$FriendDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendDetailsImplToJson(
      this,
    );
  }
}

abstract class _FriendDetails extends FriendDetails {
  const factory _FriendDetails(
          {@JsonKey(name: 'app_user') required final AppUser appUser,
          @JsonKey(name: 'mutual_friends')
          required final ISet<AppUser> mutualFriends,
          @JsonKey(name: 'public_wishlists')
          required final IList<Wishlist> publicWishlists,
          @JsonKey(name: 'nb_wishlists') required final int nbWishlists,
          @JsonKey(name: 'nb_wishs') required final int nbWishs}) =
      _$FriendDetailsImpl;
  const _FriendDetails._() : super._();

  factory _FriendDetails.fromJson(Map<String, dynamic> json) =
      _$FriendDetailsImpl.fromJson;

  @override
  @JsonKey(name: 'app_user')
  AppUser get appUser;
  @override
  @JsonKey(name: 'mutual_friends')
  ISet<AppUser> get mutualFriends;
  @override
  @JsonKey(name: 'public_wishlists')
  IList<Wishlist> get publicWishlists;
  @override
  @JsonKey(name: 'nb_wishlists')
  int get nbWishlists;
  @override
  @JsonKey(name: 'nb_wishs')
  int get nbWishs;

  /// Create a copy of FriendDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendDetailsImplCopyWith<_$FriendDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
