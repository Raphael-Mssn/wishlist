import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/shared/infra/app_exception.dart';

/// Retourne la clé de message utilisateur pour [e] si reconnue (ex. ancien
/// mot de passe incorrect, nouveau mot de passe identique), sinon null.
/// Testable unitairement.
AppUserMessageKey? userMessageKeyForAuthException(AuthException e) {
  final code = e.statusCode;
  if (code == null) {
    return null;
  }
  switch (code) {
    case '403':
      return AppUserMessageKey.oldPasswordIncorrect;
    case '422':
      return AppUserMessageKey.newPasswordShouldBeDifferent;
    default:
      return null;
  }
}
