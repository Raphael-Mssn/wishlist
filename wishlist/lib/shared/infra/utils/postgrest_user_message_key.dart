import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/app_exception.dart';

/// Retourne la clé de message utilisateur pour [e] si reconnue (ex. saisie
/// trop longue, pseudo déjà utilisé), sinon null. Testable unitairement.
AppUserMessageKey? userMessageKeyForPostgrestException(PostgrestException e) {
  if (e.code == '23514' && e.message.contains('_max_length')) {
    return AppUserMessageKey.inputTooLong;
  }
  if (e.code == '23505' && e.message.contains('pseudo')) {
    return AppUserMessageKey.pseudoAlreadyExists;
  }
  return null;
}
