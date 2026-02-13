import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/app_exception.dart';
import 'package:wishlist/shared/infra/utils/auth_user_message_key.dart';

void main() {
  group('userMessageKeyForAuthException', () {
    test('returns oldPasswordIncorrect when statusCode is 403', () {
      const e = AuthException('Forbidden', statusCode: '403');

      expect(
        userMessageKeyForAuthException(e),
        AppUserMessageKey.oldPasswordIncorrect,
      );
    });

    test('returns newPasswordShouldBeDifferent when statusCode is 422', () {
      const e = AuthException('Validation failed', statusCode: '422');

      expect(
        userMessageKeyForAuthException(e),
        AppUserMessageKey.newPasswordShouldBeDifferent,
      );
    });

    test('returns null when statusCode is 401', () {
      const e = AuthException('Unauthorized', statusCode: '401');

      expect(userMessageKeyForAuthException(e), isNull);
    });

    test('returns null when statusCode is null', () {
      const e = AuthException('Unknown error');

      expect(userMessageKeyForAuthException(e), isNull);
    });
  });
}
