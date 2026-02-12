import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/app_exception.dart';

/// Retourne la clé de message utilisateur pour [e] si reconnue (ex. saisie
/// trop longue), sinon null. Testable unitairement.
AppUserMessageKey? userMessageKeyForPostgrestException(PostgrestException e) {
  final isMaxLength = e.code == '23514' && e.message.contains('_max_length');
  return isMaxLength ? AppUserMessageKey.inputTooLong : null;
}
