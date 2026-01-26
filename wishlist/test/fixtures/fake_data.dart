import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/friendships_realtime_provider.dart';
import 'package:wishlist/shared/models/app_user.dart';
import 'package:wishlist/shared/models/booked_wish_with_details/booked_wish_with_details.dart';
import 'package:wishlist/shared/models/friend_details/friend_details.dart';
import 'package:wishlist/shared/models/profile.dart';
import 'package:wishlist/shared/models/wish/wish.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';

// =============================================================================
// FAKE USER IDS
// =============================================================================

const fakeCurrentUserId = 'fake-current-user-id';
const fakeFriendUserId1 = 'fake-friend-user-id-1';
const fakeFriendUserId2 = 'fake-friend-user-id-2';
const fakePendingUserId = 'fake-pending-user-id';
const fakeRequestedUserId = 'fake-requested-user-id';

// =============================================================================
// FAKE DATES
// =============================================================================

final fakeNow = DateTime(2024, 1, 15, 10, 30);
final fakeCreatedAt = DateTime(2024, 1, 1, 12);
final fakeUpdatedAt = DateTime(2024, 1, 10, 14, 30);

// =============================================================================
// FAKE WISHLISTS
// =============================================================================

// Couleurs de AppColors (voir lib/shared/theme/colors.dart)
const fakeColorBlue = '#69ABE9';
const fakeColorPurple = '#9665E5';
const fakeColorYellow = '#DBCD4D';
const fakeColorGreen = '#57BD87';

final fakeWishlist1 = Wishlist(
  id: 1,
  createdAt: fakeCreatedAt,
  name: 'Anniversaire',
  idOwner: fakeCurrentUserId,
  color: fakeColorBlue,
  endDate: DateTime(2024, 6, 15),
  canOwnerSeeTakenWish: true,
  order: 0,
  updatedBy: fakeCurrentUserId,
  updatedAt: fakeUpdatedAt,
);

final fakeWishlist2 = Wishlist(
  id: 2,
  createdAt: fakeCreatedAt,
  name: 'Noël',
  idOwner: fakeCurrentUserId,
  color: fakeColorGreen,
  endDate: DateTime(2024, 12, 25),
  visibility: WishlistVisibility.public,
  order: 1,
  updatedBy: fakeCurrentUserId,
  updatedAt: fakeUpdatedAt,
);

final fakeWishlist3 = Wishlist(
  id: 3,
  createdAt: fakeCreatedAt,
  name: 'Mariage',
  idOwner: fakeCurrentUserId,
  color: fakeColorPurple,
  order: 2,
  updatedBy: fakeCurrentUserId,
  updatedAt: fakeUpdatedAt,
);

final fakeWishlists = [fakeWishlist1, fakeWishlist2, fakeWishlist3];

// =============================================================================
// FAKE WISHES
// =============================================================================

final fakeWish1 = Wish(
  id: 1,
  createdAt: fakeCreatedAt,
  name: 'iPhone 15 Pro',
  description: 'Le dernier iPhone avec puce A17',
  price: 1199,
  linkUrl: 'https://apple.com/iphone-15-pro',
  isFavourite: true,
  quantity: 1,
  wishlistId: 1,
  updatedBy: fakeCurrentUserId,
  updatedAt: fakeUpdatedAt,
);

final fakeWish2 = Wish(
  id: 2,
  createdAt: fakeCreatedAt,
  name: 'AirPods Pro',
  description: 'Écouteurs sans fil avec réduction de bruit',
  price: 279,
  linkUrl: 'https://apple.com/airpods-pro',
  quantity: 1,
  wishlistId: 1,
  updatedBy: fakeCurrentUserId,
  updatedAt: fakeUpdatedAt,
);

final fakeWishes = [fakeWish1, fakeWish2];

// =============================================================================
// FAKE PROFILES
// =============================================================================

final fakeCurrentUserProfile = Profile(
  id: fakeCurrentUserId,
  pseudo: 'MonPseudo',
);

final fakeFriendProfile1 = Profile(
  id: fakeFriendUserId1,
  pseudo: 'Alice',
);

final fakeFriendProfile2 = Profile(
  id: fakeFriendUserId2,
  pseudo: 'Bob',
);

final fakePendingProfile = Profile(
  id: fakePendingUserId,
  pseudo: 'Charlie',
);

final fakeRequestedProfile = Profile(
  id: fakeRequestedUserId,
  pseudo: 'Diana',
);

// =============================================================================
// FAKE USERS (avec User de Supabase)
// =============================================================================

User _createFakeUser(String id) {
  return User(
    id: id,
    appMetadata: const {},
    userMetadata: const {},
    aud: 'authenticated',
    createdAt: fakeCreatedAt.toIso8601String(),
  );
}

final fakeCurrentAppUser = AppUser(
  profile: fakeCurrentUserProfile,
  user: _createFakeUser(fakeCurrentUserId),
);

final fakeFriendAppUser1 = AppUser(
  profile: fakeFriendProfile1,
  user: _createFakeUser(fakeFriendUserId1),
);

final fakeFriendAppUser2 = AppUser(
  profile: fakeFriendProfile2,
  user: _createFakeUser(fakeFriendUserId2),
);

final fakePendingAppUser = AppUser(
  profile: fakePendingProfile,
  user: _createFakeUser(fakePendingUserId),
);

final fakeRequestedAppUser = AppUser(
  profile: fakeRequestedProfile,
  user: _createFakeUser(fakeRequestedUserId),
);

// =============================================================================
// FAKE FRIENDS DATA
// =============================================================================

final fakeFriendsData = FriendsData(
  friends: [fakeFriendAppUser1, fakeFriendAppUser2].toIList(),
  pendingFriends: [fakePendingAppUser].toIList(),
  requestedFriends: [fakeRequestedAppUser].toIList(),
);

const fakeEmptyFriendsData = FriendsData(
  friends: IListConst([]),
  pendingFriends: IListConst([]),
  requestedFriends: IListConst([]),
);

// =============================================================================
// FAKE BOOKED WISHES
// =============================================================================

final fakeBookedWish1 = BookedWishWithDetails(
  wish: fakeWish1,
  bookedQuantity: 1,
  wishlistName: 'Anniversaire',
  ownerPseudo: 'Alice',
  ownerId: fakeFriendUserId1,
);

final fakeBookedWish2 = BookedWishWithDetails(
  wish: fakeWish2,
  bookedQuantity: 1,
  wishlistName: 'Noël',
  ownerPseudo: 'Bob',
  ownerId: fakeFriendUserId2,
);

final fakeBookedWishes = [fakeBookedWish1, fakeBookedWish2].toIList();

const fakeEmptyBookedWishes = IListConst<BookedWishWithDetails>([]);

// =============================================================================
// FAKE FRIEND DETAILS
// =============================================================================

final fakeFriendDetails = FriendDetails(
  appUser: fakeFriendAppUser1,
  mutualFriends: [fakeFriendAppUser2].toISet(),
  publicWishlists: [fakeWishlist1, fakeWishlist2].toIList(),
  nbWishlists: 2,
  nbWishs: 5,
);

final fakeFriendDetailsEmpty = FriendDetails(
  appUser: fakeFriendAppUser1,
  mutualFriends: const ISetConst({}),
  publicWishlists: const IListConst([]),
  nbWishlists: 0,
  nbWishs: 0,
);
