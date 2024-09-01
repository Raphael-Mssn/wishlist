import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/app_exception.dart';
import 'package:wishlist/shared/infra/non_null_extensions/go_true_client_non_null_getter_user_extension.dart';
import 'package:wishlist/shared/infra/non_null_extensions/user_non_null_getter_email_extension.dart';
import 'package:wishlist/shared/infra/repositories/user/user_repository.dart';
import 'package:wishlist/shared/models/app_user.dart';
import 'package:wishlist/shared/models/profile.dart';

class SupabaseUserRepository implements UserRepository {
  SupabaseUserRepository(this._client);
  final SupabaseClient _client;

  @override
  String getCurrentUserEmail() {
    return _client.auth.currentUserNonNull.emailNonNull;
  }

  @override
  Future<void> createUserProfile(Profile profile) async {
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

  @override
  Future<IList<AppUser>> searchUsersByEmailOrPseudo(String query) async {
    try {
      final response = await _client
          .from('users_profiles')
          .select()
          .or('profile->>pseudo.ilike.%$query%,user->>email.ilike.%$query%');

      return response.map(AppUser.fromJson).toIList();
    } on PostgrestException catch (e) {
      final statusCode = e.code;
      throw AppException(
        statusCode: statusCode != null ? int.parse(statusCode) : 500,
        message: e.message,
      );
    } catch (e) {
      throw AppException(
        statusCode: 500,
        message: 'Failed to search user by email or pseudo',
      );
    }
  }

  @override
  Future<AppUser> getAppUserById(String userId) async {
    try {
      final response = await _client
          .from('users_profiles')
          .select()
          .eq('id', userId)
          .single();

      return AppUser.fromJson(response);
    } on PostgrestException catch (e) {
      final statusCode = e.code;
      throw AppException(
        statusCode: statusCode != null ? int.parse(statusCode) : 500,
        message: e.message,
      );
    } catch (e) {
      throw AppException(
        statusCode: 500,
        message: 'Failed to get user by id',
      );
    }
  }
}
