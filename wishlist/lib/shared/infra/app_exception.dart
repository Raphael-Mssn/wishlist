import 'package:wishlist/l10n/l10n.dart';

/// Clés des messages utilisateur localisés (snackbars, etc.).
enum AppUserMessageKey {
  inputTooLong;

  /// Message localisé pour cette clé.
  String toLocalizedString(AppLocalizations l10n) {
    switch (this) {
      case AppUserMessageKey.inputTooLong:
        return l10n.inputTooLong;
    }
  }
}

class AppException implements Exception {
  AppException({
    required this.statusCode,
    required this.message,
    this.userMessageKey,
  });

  final String message;
  final int statusCode;

  /// Message utilisateur à afficher si reconnu (sinon message générique).
  final AppUserMessageKey? userMessageKey;
}
