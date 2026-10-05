import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/app_exception.dart';
import 'package:wishlist/shared/infra/utils/postgrest_user_message_key.dart';

Future<T> executeSafely<T>(
  Future<T> Function() operation, {
  required String errorMessage,
  void Function(Exception error)? customErrorHandler,
}) async {
  try {
    return await operation();
  } on AppException {
    rethrow;
  } on PostgrestException catch (e, stackTrace) {
    customErrorHandler?.call(e);

    final statusCode = e.code != null ? int.tryParse(e.code.toString()) : 500;
    Error.throwWithStackTrace(
      AppException(
        statusCode: statusCode ?? 500,
        message: e.message,
        userMessageKey: userMessageKeyForPostgrestException(e),
        cause: e,
      ),
      stackTrace,
    );
  } on StorageException catch (e, stackTrace) {
    customErrorHandler?.call(e);

    Error.throwWithStackTrace(
      AppException(
        statusCode: int.tryParse(e.statusCode ?? '500') ?? 500,
        message: e.message,
        cause: e,
      ),
      stackTrace,
    );
  } catch (e, stackTrace) {
    if (e is Exception) {
      customErrorHandler?.call(e);
    }

    Error.throwWithStackTrace(
      AppException(statusCode: 500, message: errorMessage, cause: e),
      stackTrace,
    );
  }
}
