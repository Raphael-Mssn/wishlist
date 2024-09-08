// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist_create_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WishlistCreateRequest _$WishlistCreateRequestFromJson(
    Map<String, dynamic> json) {
  return _WishlistCreateRequest.fromJson(json);
}

/// @nodoc
mixin _$WishlistCreateRequest {
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'id_owner')
  String get idOwner => throw _privateConstructorUsedError;
  @JsonKey(name: 'color')
  String get color => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_closed')
  bool get isClosed => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  DateTime? get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_owner_see_taken_wish')
  bool get canOwnerSeeTakenWish => throw _privateConstructorUsedError;
  @JsonKey(name: 'visibility')
  WishlistVisibility get visibility => throw _privateConstructorUsedError;
  @JsonKey(name: 'order')
  int get order => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_by')
  String get updatedBy => throw _privateConstructorUsedError;

  /// Serializes this WishlistCreateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WishlistCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WishlistCreateRequestCopyWith<WishlistCreateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WishlistCreateRequestCopyWith<$Res> {
  factory $WishlistCreateRequestCopyWith(WishlistCreateRequest value,
          $Res Function(WishlistCreateRequest) then) =
      _$WishlistCreateRequestCopyWithImpl<$Res, WishlistCreateRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String name,
      @JsonKey(name: 'id_owner') String idOwner,
      @JsonKey(name: 'color') String color,
      @JsonKey(name: 'icon_url') String? iconUrl,
      @JsonKey(name: 'is_closed') bool isClosed,
      @JsonKey(name: 'end_date') DateTime? endDate,
      @JsonKey(name: 'can_owner_see_taken_wish') bool canOwnerSeeTakenWish,
      @JsonKey(name: 'visibility') WishlistVisibility visibility,
      @JsonKey(name: 'order') int order,
      @JsonKey(name: 'updated_by') String updatedBy});
}

/// @nodoc
class _$WishlistCreateRequestCopyWithImpl<$Res,
        $Val extends WishlistCreateRequest>
    implements $WishlistCreateRequestCopyWith<$Res> {
  _$WishlistCreateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WishlistCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? idOwner = null,
    Object? color = null,
    Object? iconUrl = freezed,
    Object? isClosed = null,
    Object? endDate = freezed,
    Object? canOwnerSeeTakenWish = null,
    Object? visibility = null,
    Object? order = null,
    Object? updatedBy = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      idOwner: null == idOwner
          ? _value.idOwner
          : idOwner // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isClosed: null == isClosed
          ? _value.isClosed
          : isClosed // ignore: cast_nullable_to_non_nullable
              as bool,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      canOwnerSeeTakenWish: null == canOwnerSeeTakenWish
          ? _value.canOwnerSeeTakenWish
          : canOwnerSeeTakenWish // ignore: cast_nullable_to_non_nullable
              as bool,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as WishlistVisibility,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      updatedBy: null == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WishlistCreateRequestImplCopyWith<$Res>
    implements $WishlistCreateRequestCopyWith<$Res> {
  factory _$$WishlistCreateRequestImplCopyWith(
          _$WishlistCreateRequestImpl value,
          $Res Function(_$WishlistCreateRequestImpl) then) =
      __$$WishlistCreateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String name,
      @JsonKey(name: 'id_owner') String idOwner,
      @JsonKey(name: 'color') String color,
      @JsonKey(name: 'icon_url') String? iconUrl,
      @JsonKey(name: 'is_closed') bool isClosed,
      @JsonKey(name: 'end_date') DateTime? endDate,
      @JsonKey(name: 'can_owner_see_taken_wish') bool canOwnerSeeTakenWish,
      @JsonKey(name: 'visibility') WishlistVisibility visibility,
      @JsonKey(name: 'order') int order,
      @JsonKey(name: 'updated_by') String updatedBy});
}

/// @nodoc
class __$$WishlistCreateRequestImplCopyWithImpl<$Res>
    extends _$WishlistCreateRequestCopyWithImpl<$Res,
        _$WishlistCreateRequestImpl>
    implements _$$WishlistCreateRequestImplCopyWith<$Res> {
  __$$WishlistCreateRequestImplCopyWithImpl(_$WishlistCreateRequestImpl _value,
      $Res Function(_$WishlistCreateRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of WishlistCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? idOwner = null,
    Object? color = null,
    Object? iconUrl = freezed,
    Object? isClosed = null,
    Object? endDate = freezed,
    Object? canOwnerSeeTakenWish = null,
    Object? visibility = null,
    Object? order = null,
    Object? updatedBy = null,
  }) {
    return _then(_$WishlistCreateRequestImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      idOwner: null == idOwner
          ? _value.idOwner
          : idOwner // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isClosed: null == isClosed
          ? _value.isClosed
          : isClosed // ignore: cast_nullable_to_non_nullable
              as bool,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      canOwnerSeeTakenWish: null == canOwnerSeeTakenWish
          ? _value.canOwnerSeeTakenWish
          : canOwnerSeeTakenWish // ignore: cast_nullable_to_non_nullable
              as bool,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as WishlistVisibility,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
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
class _$WishlistCreateRequestImpl extends _WishlistCreateRequest {
  const _$WishlistCreateRequestImpl(
      {@JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'id_owner') required this.idOwner,
      @JsonKey(name: 'color') required this.color,
      @JsonKey(name: 'icon_url') this.iconUrl,
      @JsonKey(name: 'is_closed') this.isClosed = false,
      @JsonKey(name: 'end_date') this.endDate,
      @JsonKey(name: 'can_owner_see_taken_wish')
      this.canOwnerSeeTakenWish = false,
      @JsonKey(name: 'visibility') this.visibility = WishlistVisibility.private,
      @JsonKey(name: 'order') required this.order,
      @JsonKey(name: 'updated_by') required this.updatedBy})
      : super._();

  factory _$WishlistCreateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$WishlistCreateRequestImplFromJson(json);

  @override
  @JsonKey(name: 'name')
  final String name;
  @override
  @JsonKey(name: 'id_owner')
  final String idOwner;
  @override
  @JsonKey(name: 'color')
  final String color;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @override
  @JsonKey(name: 'is_closed')
  final bool isClosed;
  @override
  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  @override
  @JsonKey(name: 'can_owner_see_taken_wish')
  final bool canOwnerSeeTakenWish;
  @override
  @JsonKey(name: 'visibility')
  final WishlistVisibility visibility;
  @override
  @JsonKey(name: 'order')
  final int order;
  @override
  @JsonKey(name: 'updated_by')
  final String updatedBy;

  @override
  String toString() {
    return 'WishlistCreateRequest(name: $name, idOwner: $idOwner, color: $color, iconUrl: $iconUrl, isClosed: $isClosed, endDate: $endDate, canOwnerSeeTakenWish: $canOwnerSeeTakenWish, visibility: $visibility, order: $order, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WishlistCreateRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.idOwner, idOwner) || other.idOwner == idOwner) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.isClosed, isClosed) ||
                other.isClosed == isClosed) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.canOwnerSeeTakenWish, canOwnerSeeTakenWish) ||
                other.canOwnerSeeTakenWish == canOwnerSeeTakenWish) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, idOwner, color, iconUrl,
      isClosed, endDate, canOwnerSeeTakenWish, visibility, order, updatedBy);

  /// Create a copy of WishlistCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WishlistCreateRequestImplCopyWith<_$WishlistCreateRequestImpl>
      get copyWith => __$$WishlistCreateRequestImplCopyWithImpl<
          _$WishlistCreateRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WishlistCreateRequestImplToJson(
      this,
    );
  }
}

abstract class _WishlistCreateRequest extends WishlistCreateRequest {
  const factory _WishlistCreateRequest(
          {@JsonKey(name: 'name') required final String name,
          @JsonKey(name: 'id_owner') required final String idOwner,
          @JsonKey(name: 'color') required final String color,
          @JsonKey(name: 'icon_url') final String? iconUrl,
          @JsonKey(name: 'is_closed') final bool isClosed,
          @JsonKey(name: 'end_date') final DateTime? endDate,
          @JsonKey(name: 'can_owner_see_taken_wish')
          final bool canOwnerSeeTakenWish,
          @JsonKey(name: 'visibility') final WishlistVisibility visibility,
          @JsonKey(name: 'order') required final int order,
          @JsonKey(name: 'updated_by') required final String updatedBy}) =
      _$WishlistCreateRequestImpl;
  const _WishlistCreateRequest._() : super._();

  factory _WishlistCreateRequest.fromJson(Map<String, dynamic> json) =
      _$WishlistCreateRequestImpl.fromJson;

  @override
  @JsonKey(name: 'name')
  String get name;
  @override
  @JsonKey(name: 'id_owner')
  String get idOwner;
  @override
  @JsonKey(name: 'color')
  String get color;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  @JsonKey(name: 'is_closed')
  bool get isClosed;
  @override
  @JsonKey(name: 'end_date')
  DateTime? get endDate;
  @override
  @JsonKey(name: 'can_owner_see_taken_wish')
  bool get canOwnerSeeTakenWish;
  @override
  @JsonKey(name: 'visibility')
  WishlistVisibility get visibility;
  @override
  @JsonKey(name: 'order')
  int get order;
  @override
  @JsonKey(name: 'updated_by')
  String get updatedBy;

  /// Create a copy of WishlistCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WishlistCreateRequestImplCopyWith<_$WishlistCreateRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
