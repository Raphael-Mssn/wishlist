import 'package:wishlist/l10n/l10n.dart';

class PasswordValidator {
  static const int minLength = 8;

  static bool hasMinLength(String password) {
    return password.length >= minLength;
  }

  static bool hasUppercase(String password) {
    return password.contains(RegExp('[A-Z]'));
  }

  static bool hasLowercase(String password) {
    return password.contains(RegExp('[a-z]'));
  }

  static bool hasNumber(String password) {
    return password.contains(RegExp('[0-9]'));
  }

  static bool hasSpecialChar(String password) {
    return password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  static bool isValid(String? password) {
    if (password == null || password.isEmpty) {
      return false;
    }
    return hasMinLength(password) &&
        hasUppercase(password) &&
        hasLowercase(password) &&
        hasNumber(password) &&
        hasSpecialChar(password);
  }
}

String? passwordSecurityValidator(String? value, AppLocalizations l10n) {
  if (!PasswordValidator.isValid(value)) {
    return l10n.passwordSecurityError;
  }
  return null;
}
