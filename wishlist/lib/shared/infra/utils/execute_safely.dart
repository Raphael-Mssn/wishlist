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
  } on PostgrestException catch (e) {
    customErrorHandler?.call(e);

    final statusCode = e.code != null ? int.tryParse(e.code.toString()) : 500;
    throw AppException(
      statusCode: statusCode ?? 500,
      message: e.message,
      userMessageKey: userMessageKeyForPostgrestException(e),
    );
  } on StorageException catch (e) {
    customErrorHandler?.call(e);

    throw AppException(
      statusCode: int.tryParse(e.statusCode ?? '500') ?? 500,
      message: e.message,
    );
  } on Exception catch (e) {
    customErrorHandler?.call(e);

    throw AppException(statusCode: 500, message: errorMessage);
  }
}
