import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/models/profile.dart';

class AppUser {
  AppUser({
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
}
