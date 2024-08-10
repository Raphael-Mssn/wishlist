import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/main.dart';
import 'package:wishlist/shared/infra/app_exception.dart';
import 'package:wishlist/shared/models/app_user.dart';

class UserApi {
  static final UserApi _instance = UserApi();

  static UserApi get instance => _instance;

  AppUser getUser(BuildContext context) {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw AppException(
        statusCode: 401,
        message: 'User is not authenticated',
      );
    }
    final email = user.email;
    if (email == null) {
      // This should never happen
      throw AppException(
        statusCode: 400,
        message: 'User email is null',
      );
    }
    return AppUser(email: email);
  }
}

final userApiProvider = Provider((ref) => UserApi.instance);
