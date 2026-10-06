import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/app_exception.dart';
import 'package:wishlist/shared/infra/utils/execute_safely.dart';

void main() {
  group('executeSafely', () {
    test('returns the operation result', () async {
      final result = await executeSafely(
        () async => 42,
        errorMessage: 'failed',
      );

      expect(result, 42);
    });

    test('rethrows an AppException thrown by the operation as is', () async {
      final original = AppException(statusCode: 400, message: 'exists');

      await expectLater(
        executeSafely<void>(
          () async => throw original,
          errorMessage: 'failed',
        ),
        throwsA(same(original)),
      );
    });

    test('wraps a PostgrestException and keeps it as cause', () async {
      const error = PostgrestException(message: 'denied', code: '403');

      await expectLater(
        executeSafely<void>(
          () async => throw error,
          errorMessage: 'failed',
        ),
        throwsA(
          isA<AppException>()
              .having((e) => e.statusCode, 'statusCode', 403)
              .having((e) => e.message, 'message', 'denied')
              .having((e) => e.cause, 'cause', same(error)),
        ),
      );
    });

    test('wraps a StorageException and keeps it as cause', () async {
      const error = StorageException('not found', statusCode: '404');

      await expectLater(
        executeSafely<void>(
          () async => throw error,
          errorMessage: 'failed',
        ),
        throwsA(
          isA<AppException>()
              .having((e) => e.statusCode, 'statusCode', 404)
              .having((e) => e.cause, 'cause', same(error)),
        ),
      );
    });

    test('wraps any other error into a 500 with the error message', () async {
      await expectLater(
        executeSafely<void>(
          () async => throw TypeError(),
          errorMessage: 'failed',
        ),
        throwsA(
          isA<AppException>()
              .having((e) => e.statusCode, 'statusCode', 500)
              .having((e) => e.message, 'message', 'failed')
              .having((e) => e.cause, 'cause', isA<TypeError>()),
        ),
      );
    });

    test('keeps the original stack trace', () async {
      StackTrace? originalStackTrace;
      StackTrace? wrappedStackTrace;

      try {
        await executeSafely<void>(
          () async {
            try {
              throw const FormatException('bad');
            } on FormatException catch (_, stackTrace) {
              originalStackTrace = stackTrace;
              rethrow;
            }
          },
          errorMessage: 'failed',
        );
      } on AppException catch (_, stackTrace) {
        wrappedStackTrace = stackTrace;
      }

      expect(wrappedStackTrace.toString(), originalStackTrace.toString());
    });

    test('calls customErrorHandler with the original exception', () async {
      const error = PostgrestException(message: 'duplicate', code: '23505');
      Exception? handled;

      await expectLater(
        executeSafely<void>(
          () async => throw error,
          errorMessage: 'failed',
          customErrorHandler: (e) => handled = e,
        ),
        throwsA(isA<AppException>()),
      );
      expect(handled, same(error));
    });
  });
}
