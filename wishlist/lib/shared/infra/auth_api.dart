import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/main.dart';
import 'package:wishlist/shared/infra/app_exception.dart';
import 'package:wishlist/shared/navigation/routes.dart';

class AuthApi {
  static final AuthApi _instance = AuthApi();

  static AuthApi get instance => _instance;

  Future<void> signOut(BuildContext context) async {
    await supabase.auth.signOut();
    if (context.mounted) {
      await Navigator.of(context).pushReplacementNamed(AppRoutes.auth.name);
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signUp({required String email, required String password}) async {
    await supabase.auth.signUp(email: email, password: password);
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final oldPasswordIsCorrect = await confirmPasswordIsCorrect(oldPassword);
    if (!oldPasswordIsCorrect) {
      throw AppException(
        statusCode: 403,
        message: 'Old password is incorrect',
      );
    }
    try {
      await supabase.auth.updateUser(UserAttributes(password: newPassword));
    } on AuthException catch (e) {
      final statusCode = e.statusCode;
      throw AppException(
        statusCode: statusCode != null ? int.parse(statusCode) : 500,
        message: e.message,
      );
    }
  }

  Future<bool> confirmPasswordIsCorrect(String password) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw AppException(
        statusCode: 401,
        message: 'User is not authenticated',
      );
    }
    try {
      await supabase.auth
          .signInWithPassword(email: user.email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }
}

final authApiProvider = Provider((ref) => AuthApi.instance);
