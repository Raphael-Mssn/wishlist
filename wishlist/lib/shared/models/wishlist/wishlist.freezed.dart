// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Wishlist _$WishlistFromJson(Map<String, dynamic> json) {
  return _Wishlist.fromJson(json);
}

/// @nodoc
mixin _$Wishlist {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
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
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Wishlist to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
@JsonSerializable()
class _$WishlistImpl extends _Wishlist {
  const _$WishlistImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'id_owner') required this.idOwner,
      @JsonKey(name: 'color') required this.color,
      @JsonKey(name: 'icon_url') this.iconUrl,
      @JsonKey(name: 'is_closed') this.isClosed = false,
      @JsonKey(name: 'end_date') this.endDate,
      @JsonKey(name: 'can_owner_see_taken_wish')
      this.canOwnerSeeTakenWish = false,
      @JsonKey(name: 'visibility') this.visibility = WishlistVisibility.private,
      @JsonKey(name: 'order') required this.order,
      @JsonKey(name: 'updated_by') required this.updatedBy,
      @JsonKey(name: 'updated_at') required this.updatedAt})
      : super._();

  factory _$WishlistImpl.fromJson(Map<String, dynamic> json) =>
      _$$WishlistImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
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
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Wishlist(id: $id, createdAt: $createdAt, name: $name, idOwner: $idOwner, color: $color, iconUrl: $iconUrl, isClosed: $isClosed, endDate: $endDate, canOwnerSeeTakenWish: $canOwnerSeeTakenWish, visibility: $visibility, order: $order, updatedBy: $updatedBy, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WishlistImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
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
                other.updatedBy == updatedBy) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      createdAt,
      name,
      idOwner,
      color,
      iconUrl,
      isClosed,
      endDate,
      canOwnerSeeTakenWish,
      visibility,
      order,
      updatedBy,
      updatedAt);

  @override
  Map<String, dynamic> toJson() {
    return _$$WishlistImplToJson(
      this,
    );
  }
}

abstract class _Wishlist extends Wishlist {
  const factory _Wishlist(
          {@JsonKey(name: 'id') required final int id,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'name') required final String name,
          @JsonKey(name: 'id_owner') required final String idOwner,
          @JsonKey(name: 'color') required final String color,
          @JsonKey(name: 'icon_url') final String? iconUrl,
          @JsonKey(name: 'is_closed') final bool isClosed,
          @JsonKey(name: 'end_date') final DateTime? endDate,
          @JsonKey(name: 'can_owner_see_taken_wish')
          final bool canOwnerSeeTakenWish,
          @JsonKey(name: 'visibility') final WishlistVisibility visibility,
          @JsonKey(name: 'order') required final int order,
          @JsonKey(name: 'updated_by') required final String updatedBy,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$WishlistImpl;
  const _Wishlist._() : super._();

  factory _Wishlist.fromJson(Map<String, dynamic> json) =
      _$WishlistImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
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
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
}
