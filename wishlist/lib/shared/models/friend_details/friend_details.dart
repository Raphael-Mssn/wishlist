import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wishlist/shared/models/app_user.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

part 'friend_details.freezed.dart';
part 'friend_details.g.dart';

@freezed
class FriendDetails with _$FriendDetails {
  const factory FriendDetails({
    @JsonKey(name: 'app_user') required AppUser appUser,
    @JsonKey(name: 'mutual_friends') required ISet<AppUser> mutualFriends,
    @JsonKey(name: 'wishlists') required IList<Wishlist> wishlists,
    @JsonKey(name: 'nb_of_wishs') required int nbOfWishs,
  }) = _FriendDetails;

  const FriendDetails._();

  factory FriendDetails.fromJson(Map<String, dynamic> json) =>
      _$FriendDetailsFromJson(json);
}
