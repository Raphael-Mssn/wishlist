import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/app_exception.dart';

extension GoTrueClientNonNullGetterUser on GoTrueClient {
  User get currentUserNonNull {
    final user = currentUser;
    if (user == null) {
      throw AppException(
        statusCode: 401,
        message: 'User is not authenticated',
      );
    }
    return user;
  }
}
