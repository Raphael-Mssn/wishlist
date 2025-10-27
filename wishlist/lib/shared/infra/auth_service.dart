import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/main.dart';
import 'package:wishlist/shared/infra/app_exception.dart';
import 'package:wishlist/shared/infra/invalidate_all_providers.dart';
import 'package:wishlist/shared/infra/non_null_extensions/go_true_client_non_null_getter_user_extension.dart';
import 'package:wishlist/shared/navigation/routes.dart';

class AuthService {
  static final AuthService _instance = AuthService();

  static AuthService get instance => _instance;

  Future<void> signOut(BuildContext context, WidgetRef ref) async {
    await supabase.auth.signOut();
    invalidateAllProviders(ref);
    if (context.mounted) {
      AuthRoute().go(context);
    }
  }

  Future<void> signIn({
    required String identifier,
    required String password,
  }) async {
    final isEmail = EmailValidator.validate(identifier);

    if (!isEmail) {
      // Si ce n'est pas un email, on récupère l'email correspondant au pseudo
      final response = await supabase
          .from('users_profiles')
          .select('user->>email')
          .eq('profile->>pseudo', identifier)
          .maybeSingle();

      if (response == null || response['email'] == null) {
        throw AppException(
          statusCode: 404,
          message: 'User not found',
        );
      }

      identifier = response['email'];
    }

    await supabase.auth
        .signInWithPassword(email: identifier, password: password);
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
    final user = supabase.auth.currentUserNonNull;
    try {
      await supabase.auth
          .signInWithPassword(email: user.email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'wishlist://com.raphtang.wishlist/reset-password',
      );
    } on AuthException catch (e) {
      final statusCode = e.statusCode;
      throw AppException(
        statusCode: statusCode != null ? int.parse(statusCode) : 500,
        message: e.message,
      );
    }
  }
}

final authServiceProvider = Provider((ref) => AuthService.instance);
