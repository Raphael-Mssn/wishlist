// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'share_intent_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ShareIntentPayload {
  WishPrefillData? get prefill => throw _privateConstructorUsedError;
  String? get imagePath => throw _privateConstructorUsedError;

  /// Create a copy of ShareIntentPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShareIntentPayloadCopyWith<ShareIntentPayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShareIntentPayloadCopyWith<$Res> {
  factory $ShareIntentPayloadCopyWith(
          ShareIntentPayload value, $Res Function(ShareIntentPayload) then) =
      _$ShareIntentPayloadCopyWithImpl<$Res, ShareIntentPayload>;
  @useResult
  $Res call({WishPrefillData? prefill, String? imagePath});

  $WishPrefillDataCopyWith<$Res>? get prefill;
}

/// @nodoc
class _$ShareIntentPayloadCopyWithImpl<$Res, $Val extends ShareIntentPayload>
    implements $ShareIntentPayloadCopyWith<$Res> {
  _$ShareIntentPayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShareIntentPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prefill = freezed,
    Object? imagePath = freezed,
  }) {
    return _then(_value.copyWith(
      prefill: freezed == prefill
          ? _value.prefill
          : prefill // ignore: cast_nullable_to_non_nullable
              as WishPrefillData?,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of ShareIntentPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WishPrefillDataCopyWith<$Res>? get prefill {
    if (_value.prefill == null) {
      return null;
    }

    return $WishPrefillDataCopyWith<$Res>(_value.prefill!, (value) {
      return _then(_value.copyWith(prefill: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ShareIntentPayloadImplCopyWith<$Res>
    implements $ShareIntentPayloadCopyWith<$Res> {
  factory _$$ShareIntentPayloadImplCopyWith(_$ShareIntentPayloadImpl value,
          $Res Function(_$ShareIntentPayloadImpl) then) =
      __$$ShareIntentPayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({WishPrefillData? prefill, String? imagePath});

  @override
  $WishPrefillDataCopyWith<$Res>? get prefill;
}

/// @nodoc
class __$$ShareIntentPayloadImplCopyWithImpl<$Res>
    extends _$ShareIntentPayloadCopyWithImpl<$Res, _$ShareIntentPayloadImpl>
    implements _$$ShareIntentPayloadImplCopyWith<$Res> {
  __$$ShareIntentPayloadImplCopyWithImpl(_$ShareIntentPayloadImpl _value,
      $Res Function(_$ShareIntentPayloadImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShareIntentPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prefill = freezed,
    Object? imagePath = freezed,
  }) {
    return _then(_$ShareIntentPayloadImpl(
      prefill: freezed == prefill
          ? _value.prefill
          : prefill // ignore: cast_nullable_to_non_nullable
              as WishPrefillData?,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ShareIntentPayloadImpl implements _ShareIntentPayload {
  const _$ShareIntentPayloadImpl({this.prefill, this.imagePath});

  @override
  final WishPrefillData? prefill;
  @override
  final String? imagePath;

  @override
  String toString() {
    return 'ShareIntentPayload(prefill: $prefill, imagePath: $imagePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShareIntentPayloadImpl &&
            (identical(other.prefill, prefill) || other.prefill == prefill) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath));
  }

  @override
  int get hashCode => Object.hash(runtimeType, prefill, imagePath);

  /// Create a copy of ShareIntentPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShareIntentPayloadImplCopyWith<_$ShareIntentPayloadImpl> get copyWith =>
      __$$ShareIntentPayloadImplCopyWithImpl<_$ShareIntentPayloadImpl>(
          this, _$identity);
}

abstract class _ShareIntentPayload implements ShareIntentPayload {
  const factory _ShareIntentPayload(
      {final WishPrefillData? prefill,
      final String? imagePath}) = _$ShareIntentPayloadImpl;

  @override
  WishPrefillData? get prefill;
  @override
  String? get imagePath;

  /// Create a copy of ShareIntentPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShareIntentPayloadImplCopyWith<_$ShareIntentPayloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
