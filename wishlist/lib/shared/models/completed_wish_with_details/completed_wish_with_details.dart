import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

part 'completed_wish_with_details.freezed.dart';
part 'completed_wish_with_details.g.dart';

@freezed
class CompletedWishWithDetails with _$CompletedWishWithDetails {
  const factory CompletedWishWithDetails({
    required Wish wish,
    @JsonKey(name: 'from_wishlist_id') required int fromWishlistId,
    @JsonKey(name: 'from_wishlist_name') required String fromWishlistName,
    @JsonKey(name: 'owner_pseudo') required String ownerPseudo,
    @JsonKey(name: 'owner_id') required String ownerId,
    @JsonKey(name: 'owner_avatar_url') String? ownerAvatarUrl,
    @JsonKey(name: 'created_at') required DateTime completedAt,
    @JsonKey(name: 'quantity') required int quantity,
  }) = _CompletedWishWithDetails;

  const CompletedWishWithDetails._();

  factory CompletedWishWithDetails.fromJson(Map<String, dynamic> json) =>
      _$CompletedWishWithDetailsFromJson(json);
}
