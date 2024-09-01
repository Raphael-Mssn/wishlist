import 'package:freezed_annotation/freezed_annotation.dart';

part 'friendship.freezed.dart';
part 'friendship.g.dart';

@freezed
class Friendship with _$Friendship {
  const factory Friendship({
    @JsonKey(name: 'status') required FriendshipStatus status,
    @JsonKey(name: 'requester_id') required String requesterId,
    @JsonKey(name: 'receiver_id') required String receiverId,
  }) = _Friendship;

  const Friendship._();

  factory Friendship.fromJson(Map<String, dynamic> json) =>
      _$FriendshipFromJson(json);

  @JsonKey(includeToJson: false, includeFromJson: true)
  int get id => 0;

  @JsonKey(includeToJson: false, includeFromJson: true)
  DateTime get createdAt => DateTime.now();

  @JsonKey(includeToJson: false, includeFromJson: true)
  DateTime get updatedAt => DateTime.now();
}

enum FriendshipStatus {
  none,
  accepted,
  pending,
  rejected,
  blocked;

  @override
  String toString() {
    switch (this) {
      case FriendshipStatus.none:
        return 'none';
      case FriendshipStatus.accepted:
        return 'accepted';
      case FriendshipStatus.pending:
        return 'pending';
      case FriendshipStatus.rejected:
        return 'rejected';
      case FriendshipStatus.blocked:
        return 'blocked';
    }
  }
}
