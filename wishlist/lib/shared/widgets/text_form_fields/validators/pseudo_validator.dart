import 'package:wishlist/l10n/l10n.dart';

String? pseudoValidator(String? value, AppLocalizations l10n) {
  if (value == null || value.isEmpty) {
    return l10n.validPseudoError;
  }
  return null;
}
