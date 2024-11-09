import 'package:wishlist/l10n/l10n.dart';

String? notNullValidator(String? value, AppLocalizations l10n) {
  if (value == null || value.isEmpty) {
    return l10n.notNullError;
  }
  return null;
}
