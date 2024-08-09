import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/main.dart';
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
}

final authApiProvider = Provider((ref) => AuthApi.instance);
