import 'package:wishlist/l10n/l10n.dart';

/// Clés des messages utilisateur localisés (snackbars, etc.).
enum AppUserMessageKey {
  inputTooLong,
  pseudoAlreadyExists,
  newPasswordShouldBeDifferent,
  oldPasswordIncorrect;

  /// Message localisé pour cette clé.
  String toLocalizedString(AppLocalizations l10n) {
    switch (this) {
      case AppUserMessageKey.inputTooLong:
        return l10n.inputTooLong;
      case AppUserMessageKey.pseudoAlreadyExists:
        return l10n.pseudoAlreadyExists;
      case AppUserMessageKey.newPasswordShouldBeDifferent:
        return l10n.newPasswordShouldBeDifferent;
      case AppUserMessageKey.oldPasswordIncorrect:
        return l10n.oldPasswordIncorrect;
    }
  }
}

class AppException implements Exception {
  AppException({
    required this.statusCode,
    this.message,
    this.userMessageKey,
  });

  final int statusCode;

  /// Message technique pour le debug / logs (jamais affiché à l'utilisateur).
  final String? message;

  /// Message utilisateur à afficher si reconnu (sinon message générique).
  final AppUserMessageKey? userMessageKey;

  @override
  String toString() {
    final key = userMessageKey != null ? ', $userMessageKey' : '';
    final msg = message != null ? ', $message' : '';
    return 'AppException($statusCode$key$msg)';
  }
}
