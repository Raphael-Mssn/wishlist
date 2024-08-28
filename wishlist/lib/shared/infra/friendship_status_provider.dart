import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/friendship_service.dart';
import 'package:wishlist/shared/models/friendship/friendship.dart';

final friendshipStatusProvider =
    FutureProvider.family<FriendshipStatus, String>((ref, userId) async {
  return ref
      .read(friendshipServiceProvider)
      .currentUserFriendshipStatusWith(userId);
});
