import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wishlist/shared/infra/utils/update_entity.dart';
import 'package:wishlist/shared/models/wish_taken_by_user/wish_taken_by_user.dart';
import 'package:wishlist/shared/utils/optional.dart';

part 'wish.freezed.dart';
part 'wish.g.dart';

@Freezed(copyWith: false)
class Wish with _$Wish implements Updatable {
  const factory Wish({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') required String description,
    @JsonKey(name: 'price') double? price,
    @JsonKey(name: 'link_url') String? linkUrl,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'is_favourite') @Default(false) bool isFavourite,
    @JsonKey(name: 'quantity') required int quantity,
    @JsonKey(name: 'wishlist_id') required int wishlistId,
    @JsonKey(name: 'updated_by') required String updatedBy,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'taken_by_user', includeToJson: false)
    @Default(IListConst([]))
    IList<WishTakenByUser> takenByUser,
  }) = _Wish;

  const Wish._();

  factory Wish.fromJson(Map<String, dynamic> json) => _$WishFromJson(json);

  /// Quantité totale réservée par tous les utilisateurs
  int get totalBookedQuantity => takenByUser.fold(
        0,
        (sum, reservation) => sum + reservation.quantity,
      );

  /// Quantité disponible restante
  int get availableQuantity => quantity - totalBookedQuantity;

  /// Vérifie si le wish est entièrement réservé
  bool get isFullyBooked => availableQuantity <= 0;

  @override
  Wish copyWith({
    String? name,
    String? description,
    Optional<double?>? price,
    String? linkUrl,
    String? iconUrl,
    bool? isFavourite,
    int? quantity,
    int? wishlistId,
    String? updatedBy,
    DateTime? updatedAt,
    IList<WishTakenByUser>? takenByUser,
  }) {
    return Wish(
      id: id,
      createdAt: createdAt,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price.orKeep(this.price),
      linkUrl: linkUrl ?? this.linkUrl,
      iconUrl: iconUrl ?? this.iconUrl,
      isFavourite: isFavourite ?? this.isFavourite,
      quantity: quantity ?? this.quantity,
      wishlistId: wishlistId ?? this.wishlistId,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
      takenByUser: takenByUser ?? this.takenByUser,
    );
  }
}
