import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/app_exception.dart';
import 'package:wishlist/shared/infra/non_null_extensions/go_true_client_non_null_getter_user_extension.dart';
import 'package:wishlist/shared/infra/non_null_extensions/user_non_null_getter_email_extension.dart';
import 'package:wishlist/shared/infra/repositories/user/user_repository.dart';
import 'package:wishlist/shared/infra/utils/execute_safely.dart';
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
  String getCurrentUserId() {
    return _client.auth.currentUserNonNull.id;
  }

  @override
  Future<void> createUserProfile(Profile profile) async {
    return executeSafely(
      () async {
        await _client.from('profiles').insert(profile.toJson());
        await _client.auth.refreshSession();
      },
      errorMessage: 'Failed to create user profile',
      customErrorHandler: (error) {
        if (error is PostgrestException && error.code == '23505') {
          throw AppException(
            statusCode: 409,
            message: 'User profile already exists',
          );
        }
      },
    );
  }

  @override
  Future<IList<AppUser>> searchUsersByEmailOrPseudo(String query) async {
    return executeSafely(
      () async {
        final response = await _client
            .from('users_profiles')
            .select()
            .or('profile->>pseudo.ilike.%$query%,user->>email.ilike.%$query%');

        return response.map(AppUser.fromJson).toIList();
      },
      errorMessage: 'Failed to search user by email or pseudo',
    );
  }

  @override
  Future<AppUser> getAppUserById(String userId) async {
    return executeSafely(
      () async {
        final response = await _client
            .from('users_profiles')
            .select()
            .eq('id', userId)
            .single();

        return AppUser.fromJson(response);
      },
      errorMessage: 'Failed to get user by id',
    );
  }
}
