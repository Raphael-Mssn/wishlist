import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/app_exception.dart';

extension UserNonNullGetterEmail on User {
  String get emailNonNull {
    final email = this.email;
    if (email == null) {
      throw AppException(
        statusCode: 400,
        message: 'User email is null',
      );
    }
    return email;
  }
}
