// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wish_prefill_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WishPrefillData {
  String? get name => throw _privateConstructorUsedError;
  String? get linkUrl => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;

  /// Create a copy of WishPrefillData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WishPrefillDataCopyWith<WishPrefillData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WishPrefillDataCopyWith<$Res> {
  factory $WishPrefillDataCopyWith(
          WishPrefillData value, $Res Function(WishPrefillData) then) =
      _$WishPrefillDataCopyWithImpl<$Res, WishPrefillData>;
  @useResult
  $Res call(
      {String? name, String? linkUrl, String? description, double? price});
}

/// @nodoc
class _$WishPrefillDataCopyWithImpl<$Res, $Val extends WishPrefillData>
    implements $WishPrefillDataCopyWith<$Res> {
  _$WishPrefillDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WishPrefillData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? linkUrl = freezed,
    Object? description = freezed,
    Object? price = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      linkUrl: freezed == linkUrl
          ? _value.linkUrl
          : linkUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WishPrefillDataImplCopyWith<$Res>
    implements $WishPrefillDataCopyWith<$Res> {
  factory _$$WishPrefillDataImplCopyWith(_$WishPrefillDataImpl value,
          $Res Function(_$WishPrefillDataImpl) then) =
      __$$WishPrefillDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? name, String? linkUrl, String? description, double? price});
}

/// @nodoc
class __$$WishPrefillDataImplCopyWithImpl<$Res>
    extends _$WishPrefillDataCopyWithImpl<$Res, _$WishPrefillDataImpl>
    implements _$$WishPrefillDataImplCopyWith<$Res> {
  __$$WishPrefillDataImplCopyWithImpl(
      _$WishPrefillDataImpl _value, $Res Function(_$WishPrefillDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of WishPrefillData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? linkUrl = freezed,
    Object? description = freezed,
    Object? price = freezed,
  }) {
    return _then(_$WishPrefillDataImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      linkUrl: freezed == linkUrl
          ? _value.linkUrl
          : linkUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

class _$WishPrefillDataImpl extends _WishPrefillData {
  const _$WishPrefillDataImpl(
      {this.name, this.linkUrl, this.description, this.price})
      : super._();

  @override
  final String? name;
  @override
  final String? linkUrl;
  @override
  final String? description;
  @override
  final double? price;

  @override
  String toString() {
    return 'WishPrefillData(name: $name, linkUrl: $linkUrl, description: $description, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WishPrefillDataImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.linkUrl, linkUrl) || other.linkUrl == linkUrl) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, name, linkUrl, description, price);

  /// Create a copy of WishPrefillData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WishPrefillDataImplCopyWith<_$WishPrefillDataImpl> get copyWith =>
      __$$WishPrefillDataImplCopyWithImpl<_$WishPrefillDataImpl>(
          this, _$identity);
}

abstract class _WishPrefillData extends WishPrefillData {
  const factory _WishPrefillData(
      {final String? name,
      final String? linkUrl,
      final String? description,
      final double? price}) = _$WishPrefillDataImpl;
  const _WishPrefillData._() : super._();

  @override
  String? get name;
  @override
  String? get linkUrl;
  @override
  String? get description;
  @override
  double? get price;

  /// Create a copy of WishPrefillData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WishPrefillDataImplCopyWith<_$WishPrefillDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
