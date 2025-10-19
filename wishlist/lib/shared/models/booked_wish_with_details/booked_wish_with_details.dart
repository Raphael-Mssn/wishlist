import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

part 'booked_wish_with_details.freezed.dart';
part 'booked_wish_with_details.g.dart';

@freezed
class BookedWishWithDetails with _$BookedWishWithDetails {
  const factory BookedWishWithDetails({
    required Wish wish,
    @JsonKey(name: 'booked_quantity') required int bookedQuantity,
    @JsonKey(name: 'wishlist_name') required String wishlistName,
    @JsonKey(name: 'owner_pseudo') required String ownerPseudo,
    @JsonKey(name: 'owner_id') required String ownerId,
    @JsonKey(name: 'owner_avatar_url') String? ownerAvatarUrl,
  }) = _BookedWishWithDetails;

  const BookedWishWithDetails._();

  factory BookedWishWithDetails.fromJson(Map<String, dynamic> json) =>
      _$BookedWishWithDetailsFromJson(json);
}
