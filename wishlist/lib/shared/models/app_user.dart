import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/models/profile.dart';

@immutable
class AppUser {
  const AppUser({
    required this.profile,
    required this.user,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    final userFromJson = User.fromJson(json['user'] as Map<String, dynamic>);

    if (userFromJson == null) {
      throw Exception('User is null');
    }
    return AppUser(
      profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
      user: userFromJson,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile': profile.toJson(),
      'user': user.toJson(),
    };
  }

  final Profile profile;
  final User user;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is AppUser && other.user.id == user.id;
  }

  @override
  int get hashCode => user.id.hashCode;
}
