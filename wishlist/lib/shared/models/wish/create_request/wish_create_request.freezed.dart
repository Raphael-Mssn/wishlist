// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wish_create_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WishCreateRequest _$WishCreateRequestFromJson(Map<String, dynamic> json) {
  return _WishCreateRequest.fromJson(json);
}

/// @nodoc
mixin _$WishCreateRequest {
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'price')
  double? get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'link_url')
  String? get linkUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_favourite')
  bool get isFavourite => throw _privateConstructorUsedError;
  @JsonKey(name: 'quantity')
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'wishlist_id')
  int get wishlistId => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_by')
  String get updatedBy => throw _privateConstructorUsedError;

  /// Serializes this WishCreateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WishCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WishCreateRequestCopyWith<WishCreateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WishCreateRequestCopyWith<$Res> {
  factory $WishCreateRequestCopyWith(
          WishCreateRequest value, $Res Function(WishCreateRequest) then) =
      _$WishCreateRequestCopyWithImpl<$Res, WishCreateRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String name,
      @JsonKey(name: 'description') String description,
      @JsonKey(name: 'price') double? price,
      @JsonKey(name: 'link_url') String? linkUrl,
      @JsonKey(name: 'icon_url') String? iconUrl,
      @JsonKey(name: 'is_favourite') bool isFavourite,
      @JsonKey(name: 'quantity') int quantity,
      @JsonKey(name: 'wishlist_id') int wishlistId,
      @JsonKey(name: 'updated_by') String updatedBy});
}

/// @nodoc
class _$WishCreateRequestCopyWithImpl<$Res, $Val extends WishCreateRequest>
    implements $WishCreateRequestCopyWith<$Res> {
  _$WishCreateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WishCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? price = freezed,
    Object? linkUrl = freezed,
    Object? iconUrl = freezed,
    Object? isFavourite = null,
    Object? quantity = null,
    Object? wishlistId = null,
    Object? updatedBy = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      linkUrl: freezed == linkUrl
          ? _value.linkUrl
          : linkUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isFavourite: null == isFavourite
          ? _value.isFavourite
          : isFavourite // ignore: cast_nullable_to_non_nullable
              as bool,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      wishlistId: null == wishlistId
          ? _value.wishlistId
          : wishlistId // ignore: cast_nullable_to_non_nullable
              as int,
      updatedBy: null == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WishCreateRequestImplCopyWith<$Res>
    implements $WishCreateRequestCopyWith<$Res> {
  factory _$$WishCreateRequestImplCopyWith(_$WishCreateRequestImpl value,
          $Res Function(_$WishCreateRequestImpl) then) =
      __$$WishCreateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String name,
      @JsonKey(name: 'description') String description,
      @JsonKey(name: 'price') double? price,
      @JsonKey(name: 'link_url') String? linkUrl,
      @JsonKey(name: 'icon_url') String? iconUrl,
      @JsonKey(name: 'is_favourite') bool isFavourite,
      @JsonKey(name: 'quantity') int quantity,
      @JsonKey(name: 'wishlist_id') int wishlistId,
      @JsonKey(name: 'updated_by') String updatedBy});
}

/// @nodoc
class __$$WishCreateRequestImplCopyWithImpl<$Res>
    extends _$WishCreateRequestCopyWithImpl<$Res, _$WishCreateRequestImpl>
    implements _$$WishCreateRequestImplCopyWith<$Res> {
  __$$WishCreateRequestImplCopyWithImpl(_$WishCreateRequestImpl _value,
      $Res Function(_$WishCreateRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of WishCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? price = freezed,
    Object? linkUrl = freezed,
    Object? iconUrl = freezed,
    Object? isFavourite = null,
    Object? quantity = null,
    Object? wishlistId = null,
    Object? updatedBy = null,
  }) {
    return _then(_$WishCreateRequestImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      linkUrl: freezed == linkUrl
          ? _value.linkUrl
          : linkUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isFavourite: null == isFavourite
          ? _value.isFavourite
          : isFavourite // ignore: cast_nullable_to_non_nullable
              as bool,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      wishlistId: null == wishlistId
          ? _value.wishlistId
          : wishlistId // ignore: cast_nullable_to_non_nullable
              as int,
      updatedBy: null == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WishCreateRequestImpl extends _WishCreateRequest {
  const _$WishCreateRequestImpl(
      {@JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'description') required this.description,
      @JsonKey(name: 'price') this.price,
      @JsonKey(name: 'link_url') this.linkUrl,
      @JsonKey(name: 'icon_url') this.iconUrl,
      @JsonKey(name: 'is_favourite') this.isFavourite = false,
      @JsonKey(name: 'quantity') required this.quantity,
      @JsonKey(name: 'wishlist_id') required this.wishlistId,
      @JsonKey(name: 'updated_by') required this.updatedBy})
      : super._();

  factory _$WishCreateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$WishCreateRequestImplFromJson(json);

  @override
  @JsonKey(name: 'name')
  final String name;
  @override
  @JsonKey(name: 'description')
  final String description;
  @override
  @JsonKey(name: 'price')
  final double? price;
  @override
  @JsonKey(name: 'link_url')
  final String? linkUrl;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @override
  @JsonKey(name: 'is_favourite')
  final bool isFavourite;
  @override
  @JsonKey(name: 'quantity')
  final int quantity;
  @override
  @JsonKey(name: 'wishlist_id')
  final int wishlistId;
  @override
  @JsonKey(name: 'updated_by')
  final String updatedBy;

  @override
  String toString() {
    return 'WishCreateRequest(name: $name, description: $description, price: $price, linkUrl: $linkUrl, iconUrl: $iconUrl, isFavourite: $isFavourite, quantity: $quantity, wishlistId: $wishlistId, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WishCreateRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.linkUrl, linkUrl) || other.linkUrl == linkUrl) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.isFavourite, isFavourite) ||
                other.isFavourite == isFavourite) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.wishlistId, wishlistId) ||
                other.wishlistId == wishlistId) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, description, price,
      linkUrl, iconUrl, isFavourite, quantity, wishlistId, updatedBy);

  /// Create a copy of WishCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WishCreateRequestImplCopyWith<_$WishCreateRequestImpl> get copyWith =>
      __$$WishCreateRequestImplCopyWithImpl<_$WishCreateRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WishCreateRequestImplToJson(
      this,
    );
  }
}

abstract class _WishCreateRequest extends WishCreateRequest {
  const factory _WishCreateRequest(
          {@JsonKey(name: 'name') required final String name,
          @JsonKey(name: 'description') required final String description,
          @JsonKey(name: 'price') final double? price,
          @JsonKey(name: 'link_url') final String? linkUrl,
          @JsonKey(name: 'icon_url') final String? iconUrl,
          @JsonKey(name: 'is_favourite') final bool isFavourite,
          @JsonKey(name: 'quantity') required final int quantity,
          @JsonKey(name: 'wishlist_id') required final int wishlistId,
          @JsonKey(name: 'updated_by') required final String updatedBy}) =
      _$WishCreateRequestImpl;
  const _WishCreateRequest._() : super._();

  factory _WishCreateRequest.fromJson(Map<String, dynamic> json) =
      _$WishCreateRequestImpl.fromJson;

  @override
  @JsonKey(name: 'name')
  String get name;
  @override
  @JsonKey(name: 'description')
  String get description;
  @override
  @JsonKey(name: 'price')
  double? get price;
  @override
  @JsonKey(name: 'link_url')
  String? get linkUrl;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  @JsonKey(name: 'is_favourite')
  bool get isFavourite;
  @override
  @JsonKey(name: 'quantity')
  int get quantity;
  @override
  @JsonKey(name: 'wishlist_id')
  int get wishlistId;
  @override
  @JsonKey(name: 'updated_by')
  String get updatedBy;

  /// Create a copy of WishCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WishCreateRequestImplCopyWith<_$WishCreateRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
