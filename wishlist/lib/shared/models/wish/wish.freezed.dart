// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wish.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Wish _$WishFromJson(Map<String, dynamic> json) {
  return _Wish.fromJson(json);
}

/// @nodoc
mixin _$Wish {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
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
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'taken_by_user', includeToJson: false)
  IList<WishTakenByUser> get takenByUser => throw _privateConstructorUsedError;

  /// Serializes this Wish to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
@JsonSerializable()
class _$WishImpl extends _Wish {
  const _$WishImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'description') required this.description,
      @JsonKey(name: 'price') this.price,
      @JsonKey(name: 'link_url') this.linkUrl,
      @JsonKey(name: 'icon_url') this.iconUrl,
      @JsonKey(name: 'is_favourite') this.isFavourite = false,
      @JsonKey(name: 'quantity') required this.quantity,
      @JsonKey(name: 'wishlist_id') required this.wishlistId,
      @JsonKey(name: 'updated_by') required this.updatedBy,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'taken_by_user', includeToJson: false)
      this.takenByUser = const IListConst([])})
      : super._();

  factory _$WishImpl.fromJson(Map<String, dynamic> json) =>
      _$$WishImplFromJson(json);

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
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'taken_by_user', includeToJson: false)
  final IList<WishTakenByUser> takenByUser;

  @override
  String toString() {
    return 'Wish(id: $id, createdAt: $createdAt, name: $name, description: $description, price: $price, linkUrl: $linkUrl, iconUrl: $iconUrl, isFavourite: $isFavourite, quantity: $quantity, wishlistId: $wishlistId, updatedBy: $updatedBy, updatedAt: $updatedAt, takenByUser: $takenByUser)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WishImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
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
                other.updatedBy == updatedBy) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other.takenByUser, takenByUser));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      createdAt,
      name,
      description,
      price,
      linkUrl,
      iconUrl,
      isFavourite,
      quantity,
      wishlistId,
      updatedBy,
      updatedAt,
      const DeepCollectionEquality().hash(takenByUser));

  @override
  Map<String, dynamic> toJson() {
    return _$$WishImplToJson(
      this,
    );
  }
}

abstract class _Wish extends Wish {
  const factory _Wish(
      {@JsonKey(name: 'id') required final int id,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'name') required final String name,
      @JsonKey(name: 'description') required final String description,
      @JsonKey(name: 'price') final double? price,
      @JsonKey(name: 'link_url') final String? linkUrl,
      @JsonKey(name: 'icon_url') final String? iconUrl,
      @JsonKey(name: 'is_favourite') final bool isFavourite,
      @JsonKey(name: 'quantity') required final int quantity,
      @JsonKey(name: 'wishlist_id') required final int wishlistId,
      @JsonKey(name: 'updated_by') required final String updatedBy,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      @JsonKey(name: 'taken_by_user', includeToJson: false)
      final IList<WishTakenByUser> takenByUser}) = _$WishImpl;
  const _Wish._() : super._();

  factory _Wish.fromJson(Map<String, dynamic> json) = _$WishImpl.fromJson;

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
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(name: 'taken_by_user', includeToJson: false)
  IList<WishTakenByUser> get takenByUser;
}
