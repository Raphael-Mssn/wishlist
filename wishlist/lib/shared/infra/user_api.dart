import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/main.dart';
import 'package:wishlist/shared/models/app_user.dart';

class UserApi {
  static final UserApi _instance = UserApi();

  static UserApi get instance => _instance;

  AppUser getUser(BuildContext context) {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not found');
    }
    final email = user.email;
    if (email == null) {
      throw Exception('Email empty');
    }
    return AppUser(email: email);
  }
}

final userApiProvider = Provider((ref) => UserApi.instance);
