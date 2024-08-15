import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/app_exception.dart';
import 'package:wishlist/shared/infra/repositories/user/user_repository.dart';
import 'package:wishlist/shared/models/profile.dart';

class SupabaseUserRepository implements UserRepository {
  SupabaseUserRepository(this._client);
  final SupabaseClient _client;

  @override
  String getCurrentUserEmail() {
    final user = _client.auth.currentUser;
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
    return email;
  }

  @override
  Future<void> createUserProfile(Profile profile) async {
    final currentUser = _client.auth.currentUser;
    if (currentUser == null) {
      throw AppException(
        statusCode: 401,
        message: 'User is not authenticated',
      );
    }

    try {
      await _client.from('profiles').insert(profile.toJson());
      await _client.auth.refreshSession();
    } on PostgrestException catch (e) {
      final statusCode = e.code;
      throw AppException(
        statusCode: statusCode != null ? int.parse(statusCode) : 500,
        message: e.message,
      );
    } catch (e) {
      throw AppException(
        statusCode: 500,
        message: 'Failed to create user profile',
      );
    }
  }
}
