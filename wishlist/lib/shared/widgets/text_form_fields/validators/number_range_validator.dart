import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/widgets/text_form_fields/validators/not_null_validator.dart';

String? numberRangeValidator(
  String? value,
  int min,
  int max,
  AppLocalizations l10n,
) {
  final notNull = notNullValidator(value, l10n);
  if (notNull != null) {
    return notNull;
  }

  final n = int.tryParse(value!);
  if (n == null) {
    return l10n.invalidNumber;
  }
  if (n < min || n > max) {
    return l10n.numberRangeError(min, max);
  }
  return null;
}
